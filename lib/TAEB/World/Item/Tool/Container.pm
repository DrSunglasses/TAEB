package TAEB::World::Item::Tool::Container;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa     => 'NetHack::Item::Tool::Container',
    handles => [qw/
        contents add_item items content_knowns remove_item remove_quantity
    /],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

