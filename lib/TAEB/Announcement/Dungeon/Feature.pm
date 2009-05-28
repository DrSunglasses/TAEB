package TAEB::Announcement::Dungeon::Feature;
use MooseX::Role::Parameterized;

parameter type => (
    is  => 'ro',
    isa => 'TAEB::Type::Tile',
);

role {
    my $p = shift;
    my $type = $p->type;

    sub type { $type }
};

no MooseX::Role::Parameterized;

1;
