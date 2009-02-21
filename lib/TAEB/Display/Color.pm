package TAEB::Display::Color;
use TAEB::OO;

use overload %TAEB::Meta::Overload::default;
sub debug_line {
    my $self = shift;
    my $color = $self->color;
    $color .= 'b' if $self->bold;
    $color .= 'r' if $self->reverse;
    return $color;
}

has color => (
    is  => 'rw',
    isa => 'Int',

    # go through the accessor for canonicalization
    initializer => sub { shift->color(@_) },
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

    # They're setting to a high color, so use the low color + bold
    if ($color >= 8) {
        $self->bold(1);
        return $orig->($self, $color - 8);
    }

    $orig->($self, $color);
};

override BUILDARGS => sub {
    my $self = shift;
    if (@_ == 1 && !ref($_[0])) {
        return { color => shift };
    }
    super;
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

