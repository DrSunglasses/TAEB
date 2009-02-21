package TAEB::Display::Curses;
use TAEB::OO;
use Curses ();
use TAEB::Util ':colors';
use Time::HiRes 'gettimeofday';

extends 'TAEB::Display';
with 'TAEB::Role::Config';

has color_method => (
    is      => 'rw',
    isa     => 'Str',
    clearer => 'reset_color_method',
    lazy    => 1,
    default => sub {
        my $config = shift->config || {};
        return $config->{color_method} || 'normal';
    },
);

has glyph_method => (
    is      => 'rw',
    isa     => 'Str',
    clearer => 'reset_glyph_method',
    lazy    => 1,
    default => sub {
        my $config = shift->config || {};
        return $config->{glyph_method} || 'normal';
    },
);

has time_buffer => (
    is      => 'ro',
    isa     => 'ArrayRef[Num]',
    default => sub { [] },
);

sub institute {
    Curses::initscr;
    Curses::noecho;
    Curses::cbreak;
    Curses::start_color;
    Curses::use_default_colors;
    Curses::init_pair($_, $_, 0) for 0 .. 7;
}

augment reinitialize => sub {
    Curses::initscr;
};

sub deinitialize {
    Curses::def_prog_mode();
    Curses::endwin();
}

sub pathfinding { shift->color_method eq 'pathfind' }

sub notify {
    my $self  = shift;
    my $msg   = shift;
    my $color = shift;
    my $sleep = @_ ? shift : 3;

    return if !defined($msg) || !length($msg);

    # strip off extra lines, it's too distracting
    $msg =~ s/\n.*//s;

    Curses::move(1, 0);
    Curses::attron(Curses::COLOR_PAIR($color));
    Curses::addstr($msg);
    Curses::attroff(Curses::COLOR_PAIR($color));
    Curses::clrtoeol;

    # using TAEB->x and TAEB->y here could screw up horrifically if the dungeon
    # object isn't loaded yet, and loading it calls notify..
    $self->place_cursor(TAEB->vt->x, TAEB->vt->y);

    return if $sleep == 0;

    sleep $sleep;
    $self->redraw;
}

sub redraw {
    my $self = shift;
    my %args = @_;

    if ($args{force_clear}) {
        Curses::clear;
        Curses::refresh;
    }

    unless ($self->glyph_method eq 'nothing') {
        my $level  = $args{level} || TAEB->current_level;
        my $color_method = $self->color_method . '_color';
        my $glyph_method = $self->glyph_method . '_glyph';

        for my $y (1 .. 21) {
            Curses::move($y, 0);
            for my $x (0 .. 79) {
                my $tile = $level->at($x, $y);
                my $color = $tile->$color_method;
                my $glyph = $tile->$glyph_method;

                my $curses_color = Curses::COLOR_PAIR($color->color)
                                 | ($color->bold    ? Curses::A_BOLD    : 0)
                                 | ($color->reverse ? Curses::A_REVERSE : 0);

                Curses::addch($curses_color | ord($glyph));
            }
        }
    }

    $self->draw_botl($args{botl}, $args{status});
    $self->place_cursor;
}

sub draw_botl {
    my $self   = shift;
    my $botl   = shift;
    my $status = shift;

    return unless TAEB->state eq 'playing';

    Curses::move(22, 0);

    if (!$botl) {
        my $command = TAEB->has_action ? TAEB->action->command : '?';
        $command =~ s/\n/\\n/g;
        $command =~ s/\e/\\e/g;
        $command =~ s/\cd/^D/g;

        $botl = TAEB->checking
              ? "Checking " . TAEB->checking
              : TAEB->currently . " ($command)";
    }

    Curses::addstr($botl);

    Curses::clrtoeol;
    Curses::move(23, 0);

    if (!$status) {
        my @pieces;
        push @pieces, 'D:' . TAEB->current_level->z;
        $pieces[-1] .= uc substr(TAEB->current_level->branch, 0, 1)
            if TAEB->current_level->known_branch;
        $pieces[-1] .= ' ('. ucfirst(TAEB->current_level->special_level) .')'
            if TAEB->current_level->special_level;

        push @pieces, 'H:' . TAEB->hp;
        $pieces[-1] .= '/' . TAEB->maxhp
            if TAEB->hp != TAEB->maxhp;

        if (TAEB->spells->has_spells) {
            push @pieces, 'P:' . TAEB->power;
            $pieces[-1] .= '/' . TAEB->maxpower
                if TAEB->power != TAEB->maxpower;
        }

        push @pieces, 'A:' . TAEB->ac;
        push @pieces, 'X:' . TAEB->level;
        push @pieces, 'N:' . TAEB->nutrition;
        push @pieces, 'T:' . TAEB->turn . '/' . TAEB->step;
        push @pieces, 'S:' . TAEB->score
            if TAEB->has_score;
        push @pieces, '$' . TAEB->gold;
        push @pieces, 'P:' . TAEB->pathfinds;

        my $resistances = join '', map {  /^(c|f|p|d|sl|sh)\w+/ } TAEB->resistances;
        push @pieces, 'R:' . $resistances
            if $resistances;

        my $statuses = join '', map { ucfirst substr $_, 0, 2 } TAEB->statuses;
        push @pieces, '[' . $statuses . ']'
            if $statuses;

        my $timebuf = $self->time_buffer;
        if (@$timebuf > 1) {
            my $fps = (@$timebuf - 1) / ($$timebuf[0] - $$timebuf[-1]);
            push @pieces, sprintf "F:%1.1f", $fps;
        }

        $status = join ' ', @pieces;
    }

    Curses::addstr($status);
    Curses::clrtoeol;
}

sub place_cursor {
    my $self = shift;
    my $x    = shift || TAEB->x;
    my $y    = shift || TAEB->y;

    Curses::move($y, $x);
    Curses::refresh;
}

sub display_topline {
    my $self = shift;

    if (@_) {
        Curses::move 0, 0;
        Curses::clrtoeol;
        Curses::addstr "@_";
        $self->place_cursor;
        return;
    }

    my @messages = TAEB->parsed_messages;

    if (@messages == 0) {
        # we don't need to worry about the other rows, the map will
        # overwrite them
        Curses::move 0, 0;
        Curses::clrtoeol;
        $self->place_cursor;
        return;
    }

    while (my @msgs = splice @messages, 0, 20) {
        my $y = 0;
        for (@msgs) {
            my ($line, $matched) = @$_;

            my $chopped = length($line) > 75;
            $line = substr($line, 0, 75);

            Curses::move $y++, 0;

            my $color = $matched
                      ? Curses::COLOR_PAIR(COLOR_GREEN)
                      : Curses::COLOR_PAIR(COLOR_BROWN);

            Curses::attron($color);
            Curses::addstr($line);
            Curses::attroff($color);

            Curses::addstr '...' if $chopped;

            Curses::clrtoeol;
        }

        if (@msgs > 1) {
            $self->place_cursor;
            #sleep 1;
            #sleep 2 if @msgs > 5;
            TAEB->redraw if @messages;
        }
    }
    $self->place_cursor;
}

sub display_menu {
    my $self = shift;
}

=head2 change_draw_mode

This is a debug command. It's expected to read another character from the
keyboard deciding how to change the draw mode.

Eventually we may want a menu interface but this is fine for now.

=cut

my %mode_changes = (
    0 => {
        summary => 'Displays nothing!',
        execute => sub { shift->glyph_method('nothing') },
    },
    n => {
        summary => 'Displays normal NetHack colors',
        execute => sub { shift->color_method('normal') },
    },
    d => {
        summary => 'Sets debug coloring',
        execute => sub { shift->color_method('debug') },
    },
    e => {
        summary => 'Sets engraving coloring',
        execute => sub { shift->color_method('engraving') },
    },
    p => {
        summary => 'Sets pathfind display',
        execute => sub { shift->color_method('pathfind') },
    },
    s => {
        summary => 'Sets stepped-on coloring',
        execute => sub { shift->color_method('stepped') },
    },
    t => {
        summary => 'Sets time-since-stepped coloring',
        execute => sub { shift->color_method('time') },
    },
    l => {
        summary => 'Displays lit tiles',
        execute => sub { shift->color_method('lit') },
    },
    v => {
        summary => 'Displays tiles in LOS',
        execute => sub { shift->color_method('los') },
    },
    f => {
        summary => 'Draws floor glyphs',
        execute => sub { shift->glyph_method('floor') },
    },
    r => {
        summary => 'Resets color and floor draw modes',
        execute => sub {
            my $self = shift;
            $self->reset_color_method;
            $self->reset_glyph_method;
        },
    },
);

sub change_draw_mode {
    my $self = shift;

    my $mode = TAEB->get_key;
    return if $mode eq "\e";

    if (exists $mode_changes{$mode}) {
        $mode_changes{$mode}->{execute}->($self);
    }
    else {
        TAEB->complain("Invalid draw mode '$mode'");
    }
}

sub msg_step {
    my $self = shift;
    my $time = gettimeofday;
    my $list = $self->time_buffer;

    unshift @$list, $time;
    splice @$list, 5 if @$list > 5;
}

sub get_key { Curses::getch }

sub try_key {
    my $self = shift;

    Curses::nodelay(Curses::stdscr, 1);
    my $c = Curses::getch;
    Curses::nodelay(Curses::stdscr, 0);

    return if $c eq -1;
    return $c;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
