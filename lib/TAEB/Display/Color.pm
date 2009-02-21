package TAEB::Display::Color;
use TAEB::OO;

has color => (
    is => 'rw',
);

has bold => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

has reverse => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

around color => sub {
    my $orig = shift;
    my $self = shift;

    return $orig->($self) if !@_;

    my $color = shift;

    if ($color =~ /^\d+$/) {
        # They're setting to a high color, so use the low color + bold
        if ($color >= 8) {
            $self->color($color - 8);
            $self->bold(1);
        }
    }
    else {
        # parse color names?
    }
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

