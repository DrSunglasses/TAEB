package TAEB::World::Item;
use TAEB::OO;

has nhi => (
    is       => 'ro',
    isa      => 'NetHack::Item',
    required => 1,
);

sub new_item {
    my $self = shift;

    my $nhi = NetHack::Item->new(@_);
    my $nhi_subclass = $nhi->meta->name;

    (my $subclass = $nhi_subclass) =~ s/^NetHack/TAEB::World/;

    return $subclass->new(nhi => $nhi);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

