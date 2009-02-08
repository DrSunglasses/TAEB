package TAEB::Message;
use TAEB::OO;

has name => (
    is  => 'ro',
    isa => 'Str',
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

