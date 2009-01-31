package TAEB::World::Item::Tool::Trap;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa => 'NetHack::Item::Tool::Trap',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

