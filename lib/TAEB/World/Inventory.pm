package TAEB::World::Inventory;
use TAEB::OO;
extends 'NetHack::Inventory';

sub find {
    my $self = shift;

    for my $item (sort $self->items) {
        return $item if $item->match(@_);
    }

    return;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

