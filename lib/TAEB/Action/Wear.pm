package TAEB::Action::Wear;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item';

has '+item' => (
    required => 1,
);

sub command {
    my $self = shift;
    my $item = $self->item;

    return 'W' if $item->type eq 'armor';
    return 'P';
}

sub respond_wear_what { shift->item->slot }

# arbitrary.. we don't need anything more advanced here
sub respond_which_finger { 'l' }

sub done {
    my $self = shift;
    $self->item->is_worn(1);
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

