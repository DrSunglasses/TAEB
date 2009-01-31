package TAEB::World::Item::Armor::Shirt;
use TAEB::OO;
extends 'TAEB::World::Item::Armor';

has '+nhi' => (
    isa => 'NetHack::Item::Armor::Shirt',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

