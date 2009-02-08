package TAEB::Message::Topline::Dungeon::Tile;
use TAEB::OO;
extends 'TAEB::Message::Topline::Dungeon';

use constant name => 'tile';

use constant messages => (
    "The fountain dries up!" =>
        {type => 'floor'},
    "As the hand retreats, the fountain disappears!" =>
        {type => 'floor'},
);

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

