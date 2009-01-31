package TAEB::World::Item::Ring;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Ring',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

