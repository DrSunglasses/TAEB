package TAEB::World::Item::Wand;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Wand',
    handles => [qw/recharges_known/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

