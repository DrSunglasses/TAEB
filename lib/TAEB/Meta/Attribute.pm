package TAEB::Meta::Attribute;
use Moose;
extends 'Moose::Meta::Attribute';

has 'provided' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

around legal_options_for_inheritance => sub {
    my $orig = shift;
    my $self = shift;
    return ('provided', $self->$orig(@_));
};

no TAEB::OO;

1;

