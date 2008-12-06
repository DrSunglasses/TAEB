package TAEB::World::Item;
use TAEB::OO;
extends 'NetHack::Item';
use List::MoreUtils 'uniq';
with 'MooseX::Role::Matcher' => { default_match => 'identity' };

use overload %TAEB::Meta::Overload::default;

sub debug_line {
    my $self = shift;
    my $quan = $self->quantity == 1 ? '' : $self->quantity . 'x ';
    my $enchantment = $self->can('ench') && $self->enchantment
                    ? $self->ench . ' '
                    : '';

    my $name = $self->identity || $self->appearance;

    return
        join '',
            $quan,
            $enchantment,
            $name;
}

sub is_autopickuped {
    my $self = shift;
    return 0 if !TAEB->autopickup;

    return 1 if $self->match(appearance => 'gold piece');
    return 1 if $self->match(class => 'wand');

    return 0;
}

sub throw_range {
    my $self = shift;
    my $range = int(TAEB->numeric_strength / 2);

    if ($self->match(identity => 'heavy iron ball')) {
        $range -= int($self->weight / 100);
    }
    else {
        $range -= int($self->weight / 40);
    }

    $range = 1 if $range < 1;

    if ($self->match(identity => qr/\b(?:arrow|crossbow bolt)\b/)
        || $self->match(class => 'gem')) {
        if (0 && "Wielding a bow for arrows or crossbow for bolts or sling for gems") {
            ++$range;
        }
        elsif ($self->match('!class' => 'gem')) {
            $range = int($range / 2);
        }
    }

    # are we on Air? are we levitating?

    if ($self->match(identity => 'boulder')) {
        $range = 20;
    }
    elsif ($self->match(identity => 'Mjollnir')) {
        $range = int(($range + 1) / 2);
    }

    # are we underwater?

    return $range;
}

sub _match {
    my $self = shift;
    my $value = shift;
    my $seek = shift;

    return !defined $value if !defined $seek;
    return 0 if !defined $value;
    return $value =~ $seek if ref($seek) eq 'Regexp';
    return $seek->($value) if ref($seek) eq 'CODE';
    if (ref($seek) eq 'ARRAY') {
        for (@$seek) {
            return 1 if $self->_match($value => $_);
        }
    }
    return $value eq $seek;
}

sub match {
    my $self = shift;
    my %args = @_;

    # All the conditions must be true for true to be returned. Return
    # immediately if a false condition is found.
    for my $matcher (keys %args) {
        my ($invert, $name) = $matcher =~ /^(not_)?(.*)$/;
        my $value = $self->can($name) ? $self->$name : undef;
        my $seek = $args{$matcher};

        my $matched = $self->_match($value => $seek) ? 1 : 0;

        if ($invert) {
            return 0 if $matched;
        }
        else {
            return 0 unless $matched;
        }
    }

    return 1;
}

sub can_drop { 1 };

__PACKAGE__->install_spoilers(qw/weight base edible artifact material sdam ldam/);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

