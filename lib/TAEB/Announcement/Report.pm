package TAEB::Announcement::Report;
use TAEB::OO;
extends 'TAEB::Announcement';

use overload (
    q{""}    => 'as_string',
    fallback => 1,
);

sub profile {
    my @profile = TAEB->debug->profiler->analyze;
    return "Profile:\n"
         . join '', map { sprintf('%20s %.2g', $_->[0], $_->[2]) } @profile;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

