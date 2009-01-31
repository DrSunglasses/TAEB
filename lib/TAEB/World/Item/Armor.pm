package TAEB::World::Item::Armor;
use TAEB::OO;

has '+nhi' => (
    isa => 'NetHack::Item::Armor',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

