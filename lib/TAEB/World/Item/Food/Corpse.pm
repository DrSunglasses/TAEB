package TAEB::World::Item::Food::Corpse;
use TAEB::OO;
extends 'TAEB::World::Item::Food';

has '+nhi' => (
    isa     => 'NetHack::Item::Food::Corpse',
    handles => {
        monster => 'monster',
    },
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

