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

after incorporate_artifact => sub {
    my $self = shift;
    my $item = shift;

    my $pool_artifact = $self->artifacts->{ $item->artifact };
    if (!$pool_artifact->isa('TAEB::World::Item')) {
        $self->artifacts->{ $item->artifact } =
            TAEB::World::Item->new_from_nhi($pool_artifact);
    }
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

