package TAEB::World::Item::Weapon;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Weapon',
    handles => [qw/
        is_poisoned enchantment numeric_enchantment burnt corroded rotted rusty
        proofed proof unproof remove_damage
    /],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

