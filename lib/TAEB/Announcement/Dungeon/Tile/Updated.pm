package TAEB::Announcement::Dungeon::Tile::Updated;
use TAEB::OO;
extends 'TAEB::Announcement::Dungeon::Tile';

use constant name => 'tile_update';

has '+tile' => (
    default => sub { die "You must provide a tile for Updated" },
    lazy => 1,
);

__PACKAGE__->meta->make_immutable;

1;
