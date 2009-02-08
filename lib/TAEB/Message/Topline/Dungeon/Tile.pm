package TAEB::Message::Topline::Dungeon::Tile;
use TAEB::OO;
extends 'TAEB::Message::Topline::Dungeon';

use constant name => 'tile';

has type => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has subtype => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_subtype',
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

