package TAEB::World::Item::Spellbook;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Spellbook',
    handles => [qw/spell ink level time emergency role/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

