package TAEB::Test;
use strict;
use warnings;
use TAEB;
use parent 'Test::More';
use TAEB::Util 'sum';

our @EXPORT = qw/degrade_ok degrade_nok degrade_progression/;

sub import_extra {
    Test::More->export_to_level(2);
    strict->import;
    warnings->import;
}

sub degrade_ok {
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my $exp = shift;
    my $got = shift;

    Test::More::ok(TAEB::Spoilers::Engravings->is_degradation($exp, $got), "$exp degrades to $got");
}

sub degrade_nok {
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my $exp = shift;
    my $got = shift;

    Test::More::ok(!TAEB::Spoilers::Engravings->is_degradation($exp, $got), "$exp does not degrade to $got");
}

sub degrade_progression {
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    for (my $i = 0; $i < @_; ++$i) {
        for (my $j = $i; $j < @_; ++$j) {
            degrade_ok($_[$i] => $_[$j]);
            degrade_nok($_[$j] => $_[$i]) unless $_[$i] eq $_[$j];
        }
    }
}

1;

__END__

=head2 degrade_ok original, current

Tests whether the original string could possibly degrade to the current string.

=head2 degrade_nok original, current

Tests whether the original string could NOT possibly degrade to the current
string.

=head2 degrade_progression Str, Str, Str, [...]

Test whether a progression is possible. This will not only test adjacent
engravings, but also an engraving to all of its children.

=cut

