package TAEB::World::Item::Armor::Bodyarmor;
use TAEB::OO;
extends 'TAEB::World::Item::Armor';

has '+nhi' => (
    isa => 'NetHack::Item::Armor::Bodyarmor',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

