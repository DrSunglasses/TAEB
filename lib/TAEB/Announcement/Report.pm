package TAEB::Announcement::Report;
use TAEB::OO;
use TAEB::Util 'max';
extends 'TAEB::Announcement';

use overload (
    q{""}    => 'as_string',
    fallback => 1,
);

sub as_string {
    my $report = inner;

    my @profile = TAEB->debugger->profiler->analyze;
    if (@profile) {
        my $length = -1 * (1 + max map { length($_->[0]) } @profile);

        $report .= "\nProfile:\n"
                . join '',
                  map {
                      sprintf("  %*s %.2g%%\n", $length, $_->[0], 100*$_->[2])
                  } @profile;
    }
    return $report;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

