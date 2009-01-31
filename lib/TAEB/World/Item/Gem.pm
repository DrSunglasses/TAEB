package TAEB::World::Item::Gem;
use TAEB::OO;

has '+nhi' => (
    isa => 'NetHack::Item::Gem',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

