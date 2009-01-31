package TAEB::World::Item::Tool;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Tool',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

