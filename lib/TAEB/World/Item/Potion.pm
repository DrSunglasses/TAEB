package TAEB::World::Item::Potion;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Potion',
    handles => [qw/is_diluted is_lit light extinguish/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

