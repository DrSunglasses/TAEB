package TAEB::World::Item::Other;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Other',
    handles => [qw/is_chained_to_you statue/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

