package TAEB::World::Item::Other;
use TAEB::OO;

has '+nhi' => (
    isa => 'NetHack::Item::Other',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

