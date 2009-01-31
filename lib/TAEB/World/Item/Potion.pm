package TAEB::World::Item::Potion;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Potion',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

