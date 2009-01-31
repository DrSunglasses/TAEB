package TAEB::World::Item::Tool::Key;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa => 'NetHack::Item::Tool::Key',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

