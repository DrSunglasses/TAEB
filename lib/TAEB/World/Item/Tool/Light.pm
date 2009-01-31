package TAEB::World::Item::Tool::Light;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa => 'NetHack::Item::Tool::Light',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

