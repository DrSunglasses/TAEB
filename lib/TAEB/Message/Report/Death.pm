package TAEB::Message::Report::Death;
use TAEB::OO;
extends 'TAEB::Message::Report';

has conducts => (
    metaclass  => 'Collection::Array',
    is         => 'ro',
    isa        => 'ArrayRef',
    lazy       => 1,
    default    => sub { [] },
    auto_deref => 1,
    provides   => {
        push => 'add_conduct',
    },
);

sub as_string {
    my $self = shift;
    my $conducts = join ', ', $self->conducts;

    return << "REPORT";
Conducts: $conducts
REPORT
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

