package TAEB::World::Item::Armor;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Armor',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

