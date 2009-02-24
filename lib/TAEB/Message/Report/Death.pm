package TAEB::Message::Report::Death;
use TAEB::OO;
extends 'TAEB::Message::Report';

has conducts => (
    metaclass => 'Collection::Array',
    is        => 'ro',
    isa       => 'ArrayRef',
    lazy      => 1,
    default   => sub { [] },
    provides  => {
        push => 'add_conduct',
    },
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

