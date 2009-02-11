package TAEB::World::ItemPool;
use TAEB::OO;
extends 'NetHack::ItemPool';

use constant inventory_class => 'TAEB::World::Inventory';

around _create_item => sub {
    my $orig = shift;
    my $self = shift;

    my $nhi = $self->$orig(@_);

    my $nhi_subclass = $nhi->meta->name;

    # The right way to do this would be to search the TAEB::World::Item
    # hierarchy for the class whose nhi attribute "isa" the $nhi_subclass.
    # But this works fine. and I'm a bad person. ~ sartak
    (my $taeb_class = $nhi_subclass) =~ s/^NetHack/TAEB::World/;

    return $taeb_class->new(nhi => $nhi);
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

