package TAEB::Display;
use TAEB::OO;
use TAEB::Display::Color;
use TAEB::Display::Menu;

sub reinitialize {
    inner();
    shift->redraw(force_clear => 1);
}

sub display_menu {
    my $self = shift;
    my $menu = shift;

    inner($menu);
    $self->redraw(force_clear => 1);

    return $menu->selected;
}

sub deinitialize { }

sub notify { }

sub redraw { }

sub display_topline { }

sub place_cursor { }

sub get_key { die "get_key not implemented for " . blessed(shift) }
sub try_key { }

sub change_draw_mode { }

sub DEMOLISH { shift->deinitialize }

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

