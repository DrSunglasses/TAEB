package TAEB::Announcement::Dungeon::Tile;
use TAEB::OO;
extends 'TAEB::Announcement';

has tile => (
    is      => 'ro',
    isa     => 'TAEB::World::Tile',
    default => sub { TAEB->current_tile },
);

__PACKAGE__->meta->make_immutable;

1;

