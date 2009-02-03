package TAEB::World::Item::Armor;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa => 'NetHack::Item::Armor',
    handles => [ qw/
        ac mc is_worn enchantment numeric_enchantment burnt corroded rotted
        rusty proofed proof unproof remove_damage
    /],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

