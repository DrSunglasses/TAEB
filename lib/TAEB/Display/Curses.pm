package TAEB::Display::Curses;
use TAEB::OO;
use Curses ();
use TAEB::Util ':colors';
use Time::HiRes 'gettimeofday';
use List::Util 'max';

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

    # need to do this again for some reason
    shift->redraw(force_clear => 1);
};

sub deinitialize {
    Curses::def_prog_mode();
    Curses::endwin();
}

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

    $self->draw_botl($args{botl}, $args{status});
    $self->place_cursor;
}

sub draw_botl {
    my $self   = shift;
    my $botl   = shift;
    my $status = shift;

    return unless defined(TAEB->hp);

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

    return unless defined($x) && defined($y);

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

augment display_menu => sub {
    my $self = shift;
    my $menu = shift;

    require Data::Page;
    my $pager = Data::Page->new;
    $pager->entries_per_page(22);
    $pager->current_page(1);

    my $is_searching = 0;
    while (1) {
        $pager->total_entries(scalar $menu->items);

        $self->draw_menu($menu, $pager);

        my $c = $self->get_key;
        if ($c eq "\cr") {
            $self->redraw(force_clear => 1);
        }
        elsif ($is_searching) {
            if ($c eq "\e") {
                $is_searching = 0;
                $menu->clear_search;
            }
            elsif ($c eq "\n") {
                # If we hit enter on a search with only one result, return it
                if ($pager->total_entries == 1) {
                    $menu->select(0);
                    last;
                }

                $is_searching = 0;
            }
            elsif ($c eq "\b" || ord($c) == 127) {
                if (length($menu->search) == 0) {
                    $is_searching = 0;
                    $menu->clear_search;
                }
                else {
                    chop(my $search = $menu->search);
                    $menu->search($search);
                }
            }
            else {
                $menu->search($menu->search . $c);
            }
        }
        else {
            if (($c eq '>' || $c eq ' ') && $pager->next_page) {
                $pager->current_page($pager->next_page);
            }
            elsif ($c eq '<' && $pager->previous_page) {
                $pager->current_page($pager->previous_page);
            }
            elsif ($c eq '^') {
                $pager->current_page($pager->first_page);
            }
            elsif ($c eq '|') {
                $pager->current_page($pager->last_page);
            }
            elsif ($c eq ' ' || $c eq "\n") {
                last;
            }
            elsif ($c eq "\e") {
                $menu->clear_selections;
                last;
            }
            elsif ($c =~ /^[a-z]$/i) {
                my $index = ($pager->first - 1) + (ord(lc $c) - ord('a'));

                if ($index < $pager->last) {
                    $menu->select($index);
                    last if $menu->select_type eq 'single';
                }
            }
            elsif ($c eq ':') {
                $is_searching = 1;
                $menu->search('');
                $pager->current_page(1);
            }
        }
    }
};

sub draw_menu {
    my $self  = shift;
    my $menu  = shift;
    my $pager = shift;

    $self->redraw;

    my @rows = $menu->description;

    my $i = 0;

    if ($pager->total_entries > 0) {
        push @rows, map {
            my $sep = $menu->is_selected($_ - 1) ? '+' : '-';
            chr($i++ + ord('a')) . " $sep " . $menu->item($_ - 1)
        } $pager->first .. $pager->last;
    }

    if ($menu->has_search) {
        push @rows, $pager->total_entries . ":  " . $menu->search;
    }
    elsif ($pager->first_page == $pager->last_page) {
        push @rows, "(end) ";
    }
    else {
        push @rows, "("
                  . $pager->current_page
                  . " of "
                  . $pager->last_page
                  . ") ";
    }

    my $max_length = max map { length } @rows;

    my $x = $max_length > 50 || $pager->total_entries > 21
          ? 0
          : 78 - $max_length;

    my $row = 0;
    for (@rows) {
        Curses::move($row++, $x);
        Curses::addstr(' ' . $_);
        Curses::clrtoeol();
    };

    if ($x == 0) {
        for ($row .. 23) {
            Curses::move($_, 0);
            Curses::clrtoeol();
        }
    }

    # move to right after the (x of y) or (end) prompt
    Curses::move($row - 1, length($rows[-1]) + $x + 1);
}

=head2 change_draw_mode

This is a debug command. It's expected to read another character from the
keyboard deciding how to change the draw mode.

Eventually we may want a menu interface but this is fine for now.

=cut

my %mode_changes = (
    'Normal NetHack colors' => sub { shift->color_method('normal') },
    'Debug coloring' => sub { shift->color_method('debug') },
    'Engraving coloring' => sub { shift->color_method('engraving') },
    'Stepped-on coloring' => sub { shift->color_method('stepped') },
    'Time-since-stepped coloring' => sub { shift->color_method('time') },
    'Lit tiles' => sub { shift->color_method('lit') },
    'Line-of-sight' => sub { shift->color_method('los') },
    'Hide objects and monsters' => sub { shift->glyph_method('floor') },
    'Reset to configured settings' => sub {
        my $self = shift;
        $self->reset_color_method;
        $self->reset_glyph_method;
    },
);

sub change_draw_mode {
    my $self = shift;

    my $menu = TAEB::Display::Menu->new(
        description => "Change draw mode",
        items       => [ keys %mode_changes ],
        select_type => 'single',
    );

    defined(my $change = $self->display_menu($menu))
        or return;

    $mode_changes{$change}->($self);
}

sub msg_step {
    my $self = shift;
    my $time = gettimeofday;
    my $list = $self->time_buffer;

    unshift @$list, $time;
    splice @$list, 5 if @$list > 5;
}

sub get_key {
    Curses::refresh;
    Curses::getch;
}

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

