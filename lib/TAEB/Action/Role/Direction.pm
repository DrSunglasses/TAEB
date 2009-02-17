package TAEB::Action::Role::Direction;
use Moose::Role;
use List::MoreUtils 'none';

has direction => (
    traits   => [qw/TAEB::Provided/],
    is       => 'ro',
    isa      => 'Str',
);

has target_tile => (
    traits   => [qw/TAEB::Provided/],
    is       => 'ro',
    isa      => 'TAEB::World::Tile',
    lazy     => 1,
    default  => sub { TAEB->current_level->at_direction(shift->direction) },
);

sub respond_what_direction { shift->direction }

around target_tile => sub {
    my $orig = shift;
    my $self = shift;
    return $self->$orig() unless @_;

    my $tile = TAEB->current_level->at_direction($self->direction);
    if (@_ && none { $tile->type eq $_ } @_) {
        TAEB->log->action(blessed($self) . " can only handle tiles of type: @_", level => 'warning');
    }

    return $self->$orig();
};

no Moose::Role;

1;

