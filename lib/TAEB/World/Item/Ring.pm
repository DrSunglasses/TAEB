package TAEB::World::Item::Ring;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Ring',
    handles => [qw/is_worn enchantment numeric_enchantment hand chargeable/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

