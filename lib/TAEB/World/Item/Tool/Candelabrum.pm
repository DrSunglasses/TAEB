package TAEB::World::Item::Tool::Candelabrum;
use TAEB::OO;
extends 'TAEB::World::Item::Tool';

has '+nhi' => (
    isa     => 'NetHack::Item::Tool::Candelabrum',
    handles => [qw/candles_attached/],
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

