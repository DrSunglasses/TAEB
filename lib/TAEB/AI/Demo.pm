package TAEB::AI::Demo;
use TAEB::OO;
extends 'TAEB::AI';

sub next_action {
    my $self = shift;

    for my $name (qw/pray melee hunt descend to_stairs open_door to_door explore/) {
        my $method = "try_$name";
        my $action = $self->$method;

        next unless $action;

        $self->currently($name);
        return $action;
    }

    # We must be trapped! Search for an exit.
    $self->currently('search');
    return $self->search;
}

sub try_pray {
    return unless TAEB->can_pray;

    return unless TAEB->nutrition < 100
               || TAEB->in_pray_heal_range;

    return TAEB::Action::Pray->new;
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
    # look for the nearest tile with a down staircase
    my $path = TAEB::World::Path->first_match(sub {
        shift->type eq 'stairsdown'
    });

    return unless $path;

    return TAEB::Action::Move->new(
        path => $path,
    );
}

sub try_open_door {
    # Look around for a closed door.
    my ($monster, $direction);
    TAEB->each_adjacent(sub {
        my ($tile, $dir) = @_;

        ($door, $direction) = ($tile, $dir)
            if $tile->type eq 'closeddoor';
    });

    return unless $door;

    if ($door->locked) {
        return TAEB::Action::Kick->new(direction => $direction);
    }

    return TAEB::Action::Open->new(direction => $direction);
}

sub try_to_door {
    # look for the nearest tile with a closed door
    my $path = TAEB::World::Path->first_match(sub {
        shift->type eq 'closeddoor'
    });

    return unless $path;

    return TAEB::Action::Move->new(
        path => $path,
    );
}

sub try_explore {
    # look for the nearest tile that isn't explored
    my $path = TAEB::World::Path->first_match(sub {
        not shift->explored
    });

    return unless $path;

    return TAEB::Action::Move->new(
        path => $path,
    );
}

sub search {
    # Look around for an adjacent insufficiently-searched tile.
    my ($adjacent_search);
    TAEB->each_adjacent(sub {
        my $tile = shift;
        $adjacent_search = 1 if $tile->searched < 30;
    });

    return TAEB::Action::Search->new if $adjacent_search;


    # look for the nearest tile that isn't sufficiently searched.
    my $path = TAEB::World::Path->first_match(sub {
        shift->searched < 30
    });

    return TAEB::Action::Move->new(
        path => $path,
    );
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

