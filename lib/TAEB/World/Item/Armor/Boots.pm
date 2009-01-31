package TAEB::World::Item::Armor::Boots;
use TAEB::OO;
extends 'TAEB::World::Item::Armor';

has '+nhi' => (
    isa => 'NetHack::Item::Armor::Boots',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

