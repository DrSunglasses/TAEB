package TAEB::Spoilers::Monster;
use TAEB::OO;
use TAEB::Util qw/colors min max firstidx string_color/;
extends 'NetHack::Monster::Spoiler';

around lookup => sub {
    my $orig = shift;
    my $self = shift;
    # the arg list doesn't have to be a hash, because of default args
    my $coloridx = firstidx { $_ eq 'color' } @_;
    my $glyphidx = firstidx { $_ eq 'glyph' } @_;
    # convert numeric color values to strings
    splice @_, $coloridx + 1, 1, string_color($_[$coloridx + 1])
        if $coloridx != -1;
    # if a mimic is blue, that just means that we don't know its color
    splice @_, $coloridx, 2
        if $_[$coloridx + 1] eq 'blue'
        && $_[$glyphidx + 1] eq 'm';

    if (wantarray) {
        my @monsters = $self->$orig(@_);
        __PACKAGE__->meta->rebless_instance($_) for @monsters;
        return @monsters;
    }
    else {
        my $monster = $self->$orig(@_);
        __PACKAGE__->meta->rebless_instance($monster) if $monster;
        return $monster;
    }
};

sub _hitchance {
    # need to be above a 1dN
    my ($min_to_hit, $max_to_hit, $die_size) = @_;

    my $cases = $max_to_hit - $min_to_hit + 1;

    my $lowest_random  = max(2, $min_to_hit);
    my $highest_random = min($max_to_hit, $die_size - 1);

    my $random_cases = $highest_random - $lowest_random + 1;

    my $chance = 0;

    # no chance contribution from the auto miss range

    if ($lowest_random <= $highest_random) {
        my $avg_tohit = ($lowest_random + $highest_random) / 2;

        my $random_chance = ($avg_tohit - 1) / $die_size;

        $chance += $random_chance * $random_cases / $cases;
    }

    if ($max_to_hit > $highest_random) {
        my $min_unrandom = max($min_to_hit, $die_size);
        $chance += ($max_to_hit - $min_unrandom + 1) / $cases;
    }

    $chance;
}

sub _read_attack_string {
    my $self = shift;

    my $total_max = 0;
    my $total_avg = 0;

    # highest and lowest to-hit ('tmp' in mattacku) values, accounting
    # for AC rerolling
    my $min_to_hit = TAEB->ac + 10 + $self->hitdice;
    my $max_to_hit = TAEB->ac < 0 ? (9 + $self->hitdice) : $min_to_hit;

    my $atk_index = 0;

    for my $token (split / /, $self->attacks) {
        $atk_index++;

        # Active attacks only
        next unless $token =~ /^(.??)([0-9]+)d([0-9]+)(.??)$/;

        # Ignore the attacks of yellow and black lights, since they do
        # _large_ amounts of damage that's actually a duration (10d20
        # and 10d12 respectively).
        next if $4 eq "b" || $4 eq "h";

        # Ignore non-melee
        next if $1 eq "M" || $1 eq "B" || $1 eq "G" || $1 eq "S";

        # Ignore attacks that the player has res to
        next if $4 eq "C" && TAEB->cold_resistant;
        next if $4 eq "F" && TAEB->fire_resistant;
        next if $4 eq "E" && TAEB->shock_resistant;

        my $hitch = _hitchance($min_to_hit, $max_to_hit, 20 + $atk_index - 1);

        $hitch = 1 if $1 eq "E";

        $total_max += $2 * $3;

        # Ballpark the AC reduction, getting it right seems not worth it

        my $damage = $2 * ($3 + 1) / 2;

        if (TAEB->ac < 0) {
            my $acreduce = - TAEB->ac / 2;

            $damage -= ($acreduce * $damage) / ($acreduce + $damage);
        }

        $total_avg += $hitch * $damage;
    }

    return ($total_avg, $total_max);
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

