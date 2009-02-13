package TAEB::AI::Demo;
use TAEB::OO;

sub next_action {
    my $self = shift;

    # Is there an adjacent monster? If so, attack it.
    my $melee = $self->try_melee;
    return $melee if $melee;

    # Is there a monster in sight? If so, move next to it.
    my $hunt = $self->try_hunt;
    return $hunt if $hunt;

    # Are we on a down staircase? If so, descend.
    my $descend = $self->try_descend;
    return $descend if $descend;

    # Is there a down staircase in sight? If so, move to it.
    my $to_stairs = $self->try_to_stairs;
    return $to_stairs if $to_stairs;

    # Is there an unexplored area? If so, go to it.
    my $explore = $self->try_explore;
    return $explore if $explore;

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

