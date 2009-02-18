package TAEB::AI::Demo;
use TAEB::OO; # Moose but with a bit more added to it
extends 'TAEB::AI';

# The framework calls this method to determine what action to do next. An action
# is an instance of TAEB::Action, which is basically an object wrapper around
# a NetHack command like "s" for search.
sub next_action {
    my $self = shift;

    for my $behavior (qw/pray melee hunt descend to_stairs open_door to_door explore search/) {
        my $method = "try_$behavior";
        my $action = $self->$method;

        next unless $action;

        $self->currently($behavior);
        return $action;
    }

    # We must be trapped! Search for an exit.
    $self->currently('to_search');
    return $self->to_search;
}

# Before we begin defining behaviors, these helper methods will make our
# behavior code far more concise.

# find_adjacent finds and adjacent tile that satisfies some predicate. It takes
# a coderef and returns the (tile, direction) corresponding to the adjacent
# tile that returned true for the predicate.
sub find_adjacent {
    my $code = shift;

    my ($tile, $direction);
    TAEB->each_adjacent(sub {
        my ($t, $d) = @_;
        ($tile, $direction) = ($t, $d) if $code->($t, $d);
    });

    return $tile if !wantarray;
    return ($tile, $direction);
}

# if_adjacent takes a predicate and an action name. If the predicate returns
# true for any of the adjacent tiles, then the action will be instantiated and
# returned.
sub if_adjacent {
    my $code   = shift;
    my $action = shift;

    # Allow caller to pass in a tile type name to check for an adjacent tile
    # with that type.
    if (!ref($code)) {
        my $type = $code;
        $code = sub { shift->type eq $type };
    }

    my ($tile, $direction) = find_adjacent($code);

    return unless $direction;

    # If they pass in a coderef for action, then they need to do some additional
    # processing based on tile type. Let them decide an action name.
    $action = $action->($tile, $direction) if ref($action);

    # I think it's safe to assume that the action wants a direction, given that
    # this is if_adjacent.
    my $action_class = "TAEB::Action::\u$action";
    return $action_class->new(
        direction => $direction,
    );
}

# path_to takes a predicate (and optional arguments to pass to the pathfinder)
# and finds the closest tile that satisfies that predicate. If there is such a
# tile, then a Move action will be returned with that path.
# If you need to find a path adjacent to an unwalkable tile, then pass in
# include_endpoints => 1.
sub path_to {
    my $code = shift;

    # Allow caller to pass in a tile type name to find a tile with that type.
    if (!ref($code)) {
        my $type = $code;
        $code = sub { shift->type eq $type };
    }

    my $path = TAEB::World::Path->first_match($code, @_);

    return unless $path;

    return TAEB::Action::Move->new(
        path => $path,
    );
}

# Now behaviors.

sub try_pray {
    # can_pray returns false if we prayed recently, or our god is angry, etc.
    return unless TAEB->can_pray;

    # Only pray if we're low on nutrition or health.
    return unless TAEB->nutrition < 100
               || TAEB->in_pray_heal_range;

    return TAEB::Action::Pray->new;
}

# Find an adjacent enemy and swing at it.
sub try_melee {
    if_adjacent(sub { $_[0]->has_enemy && $_[0]->monster->is_meleeable },
        'melee',
    );
}

# Find an enemy on the level and hunt it down.
sub try_hunt {
    path_to(sub {
        my $tile = shift;

        return $tile->has_enemy
            && $tile->monster->is_meleeable
            && !$tile->monster->is_seen_through_warning
    });
}

# If we're on stairs then descend.
sub try_descend {
    return unless TAEB->current_tile->type eq 'stairsdown';

    return TAEB::Action::Descend->new;
}

# If we see stairs, then go to them.
sub try_to_stairs {
    path_to('stairsdown');
}

# If there's an adjacent closed door, try opening it. If it's locked, kick it
# down.
sub try_open_door {
    if_adjacent(closeddoor => sub {
        my $door = shift;
        return 'kick' if $door->is_locked;
        return 'open';
    });
}

# If we see a closed door, then go to it.
sub try_to_door {
    path_to('closeddoor', include_endpoints => 1);
}

# If there's an unexplored tile (tracked by the framework), go to it.
sub try_explore {
    path_to(sub { not shift->explored });
}

# If there's an unsearched tile next to us, search.
sub try_search {
    if_adjacent(sub { shift->searched < 30 } => 'search');
}

# If there's an unsearched tile, go to it.
sub to_search {
    path_to(sub { shift->searched < 30 }, include_endpoints => 1)
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

