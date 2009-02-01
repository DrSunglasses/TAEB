package TAEB::World::Item::Wand;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Wand',
    handles => [qw/
        recharges recharges_known inc_recharges charges charges_known
        set_charges_unknown subtract_charges charges_spent_this_recharge
        add_charges_spent_this_recharge reset_charges_spent_this_recharge
        times_recharged inc_times_recharged spend_charge recharge
        chance_to_recharge burnt corroded rotted rusty proofed remove_damage
        maxcharges zaptype
    /],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

