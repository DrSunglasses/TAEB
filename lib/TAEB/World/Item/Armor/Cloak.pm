package TAEB::World::Item::Armor::Cloak;
use TAEB::OO;
extends 'TAEB::World::Item::Armor';

has '+nhi' => (
    isa => 'NetHack::Item::Armor::Cloak',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

