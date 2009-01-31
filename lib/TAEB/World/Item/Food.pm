package TAEB::World::Item::Food;
use TAEB::OO;

has '+nhi' => (
    isa => 'NetHack::Item::Food',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

