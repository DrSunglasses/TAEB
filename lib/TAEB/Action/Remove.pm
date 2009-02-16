package TAEB::Action::Remove;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item';

has item => (
    traits   => [qw/TAEB::Provided/],
    isa      => 'NetHack::Item',
    required => 1,
);

sub command {
    my $self = shift;
    my $item = $self->item;

    return 'T' if $item->type eq 'armor';
    return 'R';
}

sub respond_remove_what { shift->item->slot }

sub done {
    my $self = shift;
    $self->item->is_worn(0);
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

