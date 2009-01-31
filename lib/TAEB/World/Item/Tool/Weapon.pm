package TAEB::World::Item::Tool::Weapon;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa => 'NetHack::Item::Tool::Weapon',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

