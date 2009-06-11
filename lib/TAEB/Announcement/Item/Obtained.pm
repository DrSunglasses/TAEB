package TAEB::Announcement::Item::Obtained;
use TAEB::OO;
extends 'TAEB::Announcement::Item';

use constant name => 'got_item';

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

