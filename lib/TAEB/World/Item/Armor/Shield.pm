package TAEB::World::Item::Armor::Shield;
use TAEB::OO;
extends 'TAEB::World::Item::Armor';

has '+nhi' => (
    isa => 'NetHack::Item::Armor::Shield',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

