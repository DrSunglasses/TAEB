package TAEB::World::Item::Armor::Gloves;
use TAEB::OO;
extends 'TAEB::World::Item::Armor';

has '+nhi' => (
    isa => 'NetHack::Item::Armor::Gloves',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

