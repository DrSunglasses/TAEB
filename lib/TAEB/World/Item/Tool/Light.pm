package TAEB::World::Item::Tool::Light;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa     => 'NetHack::Item::Tool::Light',
    handles => [qw/is_diluted is_lit light extinguish is_partly_used/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

