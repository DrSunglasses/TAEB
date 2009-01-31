package TAEB::World::Item::Weapon;
use TAEB::OO;

has '+nhi' => (
    isa => 'NetHack::Item::Weapon',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

