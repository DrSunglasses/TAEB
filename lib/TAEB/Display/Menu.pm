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
    $args{_item_metadata} = [ map { [$_] } @{ delete $args{items} } ];

    return \%args;
}

sub item {
    my $self = shift;
    my $index = shift;

    return $self->_item_metadata->[$index][0];
}

sub select {
    my $self = shift;

    for my $index (@_) {
        $self->_item_metadata->[$index][1] = 1;
    }
}

sub selected {
    my $self  = shift;

    return map { $_->[0] }
           grep { $_->[1] }
           @{ $self->_item_metadata }
}

sub clear_selections {
    my $self = shift;

    for my $index (0 .. @{ $self->_item_metadata } - 1) {
        $self->_item_metadata->[$index][1] = 0;
    }
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

