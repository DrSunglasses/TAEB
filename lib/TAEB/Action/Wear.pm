package TAEB::Action::Wear;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item';

use constant command => "W";

has item => (
    traits   => [qw/TAEB::Provided/],
    isa      => 'NetHack::Item',
    required => 1,
);

sub respond_wear_what { shift->item->slot }

sub done {
    my $self = shift;
    $self->item->is_worn(1);
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

