package TAEB::Action::Open;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Direction';

use constant command => 'o';

has '+direction' => (
    required => 1,
);

subscribe door => sub {
    my $self  = shift;
    my $event = shift;

    my $state = $event->state;
    my $tile  = $event->tile;

    if ($state eq 'locked') {
        $tile->state('locked');
    }
    elsif ($state eq 'resists') {
        $tile->state('unlocked');
    }
};

__PACKAGE__->meta->make_immutable;

1;

