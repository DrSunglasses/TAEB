package TAEB::World::Item::Tool;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Tool',
    handles => [qw/
        charge recharges recharges_known inc_recharges charges charges_known
        set_charges_unknown subtract_charges charges_spent_this_recharge
        add_charges_spent_this_recharge reset_charges_spent_this_recharge
        times_recharged inc_times_recharged spend_charge recharge
        chance_to_recharge burnt corroded rotted rusty proofed remove_damage
    /],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

