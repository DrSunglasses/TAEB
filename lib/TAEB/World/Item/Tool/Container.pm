package TAEB::World::Item::Tool::Container;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa => 'NetHack::Item::Tool::Container',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

