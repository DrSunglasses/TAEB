package TAEB::World::ItemPool;
use TAEB::OO;
extends 'NetHack::ItemPool';

use constant inventory_class => 'TAEB::World::Inventory';

around _create_item => sub {
    my $orig = shift;
    my $self = shift;

    my $nhi = $self->$orig(@_);

    return TAEB::World::Item->new_from_nhi($nhi);
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

