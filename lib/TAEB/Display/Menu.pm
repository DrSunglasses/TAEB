package TAEB::Display::Menu;
use TAEB::OO;

has description => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has _item_metadata => (
    is  => 'ro',
    isa => 'ArrayRef',
);

has select_type => (
    is      => 'ro',
    isa     => 'TAEB::Type::Menu',
    default => 'none',
);

sub BUILDARGS {
    my $self = shift;
    my %args = @_;

    die "Attribute (items) is required and must be an array reference"
        unless $args{items} && ref($args{items}) eq 'ARRAY';
    $args{_item_metadata} = map { [$_] } @{ delete $args{items} };

    return \%args;
}

sub select {
}

sub selected {
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

