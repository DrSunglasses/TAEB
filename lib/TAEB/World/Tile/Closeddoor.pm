package TAEB::World::Tile::Closeddoor;
use TAEB::OO;
extends 'TAEB::World::Tile::Door';
use TAEB::Util ':colors';

has '+type' => (
    default => 'closeddoor',
);

has is_shop => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

override debug_color => sub {
    my $self = shift;

    if ($self->is_shop) {
        return Curses::A_BOLD | Curses::COLOR_PAIR(COLOR_RED);
    }
    elsif ($self->is_locked) {
        return Curses::A_BOLD | Curses::COLOR_PAIR(COLOR_BROWN);
    }
    elsif ($self->is_unlocked) {
        return Curses::A_BOLD | Curses::COLOR_PAIR(COLOR_GREEN);
    }

    return super;
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

