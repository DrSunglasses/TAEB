package TAEB::Display;
use TAEB::OO;

sub reinitialize {
    inner();
    shift->redraw(force_clear => 1);
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

