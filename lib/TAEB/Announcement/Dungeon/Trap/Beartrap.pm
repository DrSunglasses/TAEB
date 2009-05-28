package TAEB::Announcement::Dungeon::Trap::Beartrap;
use TAEB::OO;
extends 'TAEB::Announcement::Dungeon::Beartrap';

use constant name => 'beartrap';

has '+type' => (
    default => 'beartrap',
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

