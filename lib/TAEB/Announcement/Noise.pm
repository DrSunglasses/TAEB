package TAEB::AI::Announcement::Noise;
use TAEB::OO;
extends 'TAEB::AI::Announcement';

use constant name => 'noise';

__PACKAGE__->parse_messages(
    'You strain a muscle.' => {},
    'You kick at empty space.' => {},
    'That hurts!' => {},
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
