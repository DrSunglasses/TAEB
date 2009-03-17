package TAEB::Announcement::Report;
use TAEB::OO;
extends 'TAEB::Announcement';

use overload (
    q{""}    => 'as_string',
    fallback => 1,
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

