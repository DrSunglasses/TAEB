package TAEB::World::Item;
use TAEB::OO;
with 'MooseX::Role::Matcher' => { default_match => 'identity' };

has nhi => (
    is       => 'ro',
    isa      => 'NetHack::Item',
    required => 1,
    handles  => {
        map { $_ => $_ } qw/
            identity slot is_wielded is_quivered is_offhand type subtype
        /,
    },
);

sub new_item {
    my $self = shift;

    my $nhi = NetHack::Item->new(@_);
    my $nhi_subclass = $nhi->meta->name;

    (my $subclass = $nhi_subclass) =~ s/^NetHack/TAEB::World/;

    return $subclass->new(nhi => $nhi);
}

# we try to uphold this API
sub isa {
    my $self = shift;

    return 1 if $_[0] eq 'NetHack::Item';

    $self->SUPER::isa(@_);
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;

