package TAEB::World::Item::Tool::Instrument;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa => 'NetHack::Item::Tool::Instrument',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

