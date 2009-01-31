package TAEB::World::Item::Spellbook;
use TAEB::OO;

has '+nhi' => (
    isa => 'NetHack::Item::Spellbook',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

