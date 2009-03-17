package TAEB::Announcement::Query::PickupItems;
use TAEB::OO;
extends 'TAEB::Announcement::Query';
with 'TAEB::Announcement::Role::SelectSubset';

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

