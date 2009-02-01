package TAEB::World::Item::Tool;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Tool',
    handles => [qw/
        charge charges recharge recharges spend_charge chance_to_recharge burnt
        corroded rotted rusty proofed remove_damage
    /],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

