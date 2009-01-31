package TAEB::World::Item::Amulet;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Amulet',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

