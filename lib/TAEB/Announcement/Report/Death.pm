package TAEB::Announcement::Report::Death;
use TAEB::OO;
extends 'TAEB::Announcement::Report';

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

has ['score', 'turns'] => (
    is  => 'rw',
    isa => 'Int',
);

augment as_string => sub {
    my $self = shift;
    my $conducts = join ', ', $self->conducts;
    my $score = $self->score;
    my $turns = $self->turns;

    return << "REPORT";
Conducts: $conducts
Score:    $score
Turns:    $turns
REPORT
};

__PACKAGE__->meta->make_immutable;

1;

