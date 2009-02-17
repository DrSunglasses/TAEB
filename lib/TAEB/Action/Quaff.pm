package TAEB::Action::Quaff;
use TAEB::OO;
extends 'TAEB::Action';

use constant command => "q";

has '+item' => (
    isa      => 'NetHack::Item::Potion | Str',
);

sub respond_drink_from {
    my $self = shift;
    my $from = shift;

    # no, we want to drink an item, not from the floor tile
    return 'n' if blessed $self->item;

    # we're specific about this. really
    return 'y' if $from eq $self->item;

    # this means something probably went wrong. respond_drink_what will catch it
    return 'n';
}

sub respond_drink_what {
    my $self = shift;
    return $self->item->slot if blessed($self->item);

    TAEB->log->action("Unable to drink from '" . $self->item . "'. Sending escape, but I doubt this will work.", level => 'error');
    return "\e";
}

sub done {
    my $self = shift;
    if (blessed $self->item) {
        TAEB->inventory->decrease_quantity($self->item->slot)
    }
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

