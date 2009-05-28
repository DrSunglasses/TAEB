package TAEB::Announcement::Dungeon::Feature;
use MooseX::Role::Parameterized;
use Moose::Util::TypeConstraints 'enum';

parameter tile_type => (
    is  => 'ro',
    isa => 'TAEB::Type::Tile',
);

parameter affect_type => (
    is  => 'ro',
    isa => (enum ['local', 'direction']),
);

role {
    my $p = shift;
    my $tile_type = $p->tile_type;

    method tile_type => sub { $tile_type };

    if ($p->affect_type eq 'local') {
        method target_tile => sub { TAEB->current_tile };
    }
    elsif ($p->affect_type eq 'direction') {
        method target_tile => sub { TAEB->action->target_tile };
    }
};

no MooseX::Role::Parameterized;

1;
