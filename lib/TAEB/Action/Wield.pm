package TAEB::Action::Wield;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item' => { items => [qw/weapon/] };

use constant command => "w";

has '+weapon' => (
    required => 1,
);

sub respond_wield_what { shift->weapon->slot }

sub done {
    my $self = shift;
    TAEB->inventory->wielded($self->weapon);
    # XXX: we need to track TAEB's offhand weapon too
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

