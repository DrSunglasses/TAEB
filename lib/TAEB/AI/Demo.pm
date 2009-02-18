package TAEB::AI::Demo;
use TAEB::OO;

sub next_action {
    my $self = shift;

    for my $name (qw/melee hunt descend to_stairs explore/) {
        my $method = "try_$name";
        my $action = $self->$method;

        return $action if $action;
    }

    # We must be trapped! Search for an exit.
    return $self->search;
}

sub try_melee {
    # Look around for a monster.
    my ($monster, $direction);
    TAEB->each_adjacent(sub {
        my ($tile, $dir) = @_;

        ($monster, $direction) = ($tile->monster, $dir)
            if $tile->has_enemy
            && $tile->monster->is_meleeable;
    });

    return unless $monster;

    # Swing!
    return TAEB::Action::Melee->new(
        direction => $direction,
    );
}

sub try_hunt {
    # look for the nearest tile with a monster
    my $path = TAEB::World::Path->first_match(sub {
        my $tile = shift;

        return $tile->has_enemy
            && $tile->monster->is_meleeable
            && !$tile->monster->is_seen_through_warning
    });

    return unless $path;

    return TAEB::Action::Move->new(
        path => $path,
    );
}

sub try_descend {
    # Can only descend while on stairs down.
    return unless TAEB->current_tile->type eq 'stairsdown';

    # Descend!
    return TAEB::Action::Descend->new;
}

sub try_to_stairs {
}

sub try_explore {
}

sub search {
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

__END__

=head1 NAME

TAEB::AI::Demo - a demonstration autonomous AI

=head1 DESCRIPTION

This is so we can have something that *plays* NetHack in the core TAEB distro,
a default AI. We could use L<TAEB::AI::Behavioral> but that is a separate
distribution so it's not a great idea.

This is also an example AI for people interested in writing one.

=cut

