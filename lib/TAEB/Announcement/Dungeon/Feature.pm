package TAEB::Announcement::Dungeon::Feature;
use MooseX::Role::Parameterized;
use Moose::Util::TypeConstraints 'enum';

parameter tile_type => (
    is  => 'ro',
    isa => 'TAEB::Type::Tile',
);

parameter target_type => (
    is  => 'ro',
    isa => (enum ['local', 'direction']),
);

role {
    my $p = shift;
    my $tile_type = $p->tile_type;

    method tile_type => sub { $tile_type };

    if ($p->target_type) {
        has target_tile => (
            is      => 'ro',
            isa     => 'TAEB::World::Tile',
            builder => '_build_target_tile',
        );

        if ($p->target_type eq 'local') {
            method _build_target_tile => sub { TAEB->current_tile };
        }
        elsif ($p->target_type eq 'direction') {
            method _build_target_tile => sub { TAEB->action->target_tile };
        }
    }
};

no MooseX::Role::Parameterized;

1;
