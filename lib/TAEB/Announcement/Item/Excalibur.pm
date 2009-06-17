package TAEB::Announcement;
use TAEB::OO;
extends 'TAEB::Announcement::Item';

has '+item' => (
    default => sub { TAEB->action->item },
);

__PACKAGE__->parse_messages(
    "From the murky depths, a hand reaches up to bless the sword." => {}
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
