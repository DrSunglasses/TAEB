package TAEB::World::Item::Wand;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Wand',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

