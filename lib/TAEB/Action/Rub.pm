package TAEB::Action::Rub;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item';

use constant command => "#rub\n";

has '+item' => (
    isa      => 'NetHack::Item',
    required => 1,
);

has against => (
    traits => [qw/TAEB::Provided/],
    is     => 'ro',
    isa    => 'NetHack::Item',
);

sub respond_rub_what { shift->item->slot }

sub respond_rub_on_what { shift->against->slot }

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

