package TAEB::Announcement::Dungeon::Feature;
use MooseX::Role::Parameterized;

parameter tile_type => (
    is  => 'ro',
    isa => 'TAEB::Type::Tile',
);

role {
    my $p = shift;
    my $tile_type = $p->tile_type;

    sub tile_type { $tile_type }
};

no MooseX::Role::Parameterized;

1;
