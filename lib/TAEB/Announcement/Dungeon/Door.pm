package TAEB::Announcement::Dungeon::Door;
use TAEB::OO;
extends 'TAEB::Announcement::Dungeon';

has state => (
    is  => 'ro',
    isa => 'Str', # more general than DoorState
);

has door => (
    is      => 'ro',
    isa     => 'TAEB::World::Tile::Door',
    default => sub {
        my $action = TAEB->action;
        confess "Unable to figure out the door tile from action $action"
            unless $action->does('TAEB::Action::Role::Direction');
        return $action->target_tile;
    },
);

use constant name => 'door';

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

