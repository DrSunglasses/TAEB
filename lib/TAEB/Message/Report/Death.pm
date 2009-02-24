package TAEB::Message::Report::Death;
use TAEB::OO;
extends 'TAEB::Message::Report';

has conducts => (
    is  => 'rw',
    isa => 'ArrayRef',
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

