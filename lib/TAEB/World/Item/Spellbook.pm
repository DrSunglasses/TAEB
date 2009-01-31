package TAEB::World::Item::Spellbook;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Spellbook',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

