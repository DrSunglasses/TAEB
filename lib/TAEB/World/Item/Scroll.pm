package TAEB::World::Item::Scroll;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Scroll',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

