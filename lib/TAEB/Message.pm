package TAEB::Message;
use TAEB::OO;

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

