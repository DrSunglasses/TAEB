package TAEB::Display;
use TAEB::OO;

sub reinitialize {
    inner();
    shift->redraw(force_clear => 1);
}

sub deinitialize { }

sub notify { }

sub redraw { }

sub display_topline { }

sub DEMOLISH { shift->deinitialize }

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

