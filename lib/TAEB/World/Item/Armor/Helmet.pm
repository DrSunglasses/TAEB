package TAEB::World::Item::Armor::Helmet;
use TAEB::OO;
extends 'TAEB::World::Item::Armor';

has '+nhi' => (
    isa => 'NetHack::Item::Armor::Helmet',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

