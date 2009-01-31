package TAEB::World::Item::Tool::Figurine;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa => 'NetHack::Item::Tool::Figurine',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

