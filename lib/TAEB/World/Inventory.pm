package TAEB::World::Inventory;
use TAEB::OO;
extends 'NetHack::Inventory';

use overload %TAEB::Meta::Overload::default;

sub find {
    my $self = shift;

    for my $item ($self->items) {
        return $item if $item->match(@_);
    }

    return;
}

=head2 has_projectile

Returns true (actually, the item) if TAEB has something useful to throw.

=cut

my @projectiles = (
    qr/\bdagger\b/,
    qr/\bspear\b/,
    qr/\bshuriken\b/,
    qr/\bdart\b/,
    "rock", # to not catch rock mole corpses
);

sub has_projectile {
    my $self = shift;

    return $self->find(
        identity    => \@projectiles,
        is_wielding => 0,
        price       => 0,
    );
}

sub debug_line {
    my $self = shift;
    my @items;

    return "No inventory." unless $self->has_items;

    for my $slot (sort $self->slots) {
        push @items, sprintf '%s - %s', $slot, $self->get($slot)->debug_line;
    }

    return join "\n", @items;
}

sub msg_got_item {
    my $self = shift;
    my $item = shift;

    $self->update($item->slot => $item);
}

sub msg_lost_item {
    my $self = shift;
    my $item = shift;

    # XXX
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

