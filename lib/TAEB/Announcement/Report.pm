package TAEB::Announcement::Report;
use TAEB::OO;
extends 'TAEB::Announcement';

use overload (
    q{""}    => 'as_string',
    fallback => 1,
);

sub as_string {
    my $report = inner;

    my @profile = TAEB->debugger->profiler->analyze;
    if (@profile) {
        $report .= "Profile:\n"
                . join '',
                  map { sprintf("%-20s %.2g\n", $_->[0], $_->[2]) }
                  @profile;
    }
    return $report;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

