package TAEB::World::Item;
use TAEB::OO;

has nhi => (
    is       => 'ro',
    isa      => 'NetHack::Item',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

