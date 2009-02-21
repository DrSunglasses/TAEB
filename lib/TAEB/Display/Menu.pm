package TAEB::Display::Menu;
use TAEB::OO;

has description => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has items => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

has select_type => (
    is      => 'ro',
    isa     => 'TAEB::Type::Menu',
    default => 'none',
);

sub select {
}

sub selected {
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

