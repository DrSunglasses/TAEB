package TAEB::World::Item::Scroll;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Scroll',
    handles => [qw/ink/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

