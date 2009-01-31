package TAEB::World::Item::Potion;
use TAEB::OO;

has '+nhi' => (
    isa => 'NetHack::Item::Potion',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

