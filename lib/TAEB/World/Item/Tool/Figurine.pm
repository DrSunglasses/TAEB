package TAEB::World::Item::Tool::Figurine;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa     => 'NetHack::Item::Tool::Figurine',
    handles => [qw/figurine/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

