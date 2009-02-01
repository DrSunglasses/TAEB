package TAEB::World::Item::Gem;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Gem',
    handles => [qw/hardness softness/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

