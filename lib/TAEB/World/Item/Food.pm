package TAEB::World::Item::Food;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Food',
    handles => {
        nutrition => 'nutrition',
    },
);

sub is_safely_edible {
    my $self = shift;

    return 0;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

