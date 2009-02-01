package TAEB::World::Item::Tool::Accessory;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa     => 'NetHack::Item::Tool::Accessory',
    handles => [qw/is_worn/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

