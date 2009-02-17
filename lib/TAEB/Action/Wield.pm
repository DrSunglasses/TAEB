package TAEB::Action::Wield;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item' => { items => [qw/weapon/] };

use constant command => "w";

has '+weapon' => (
    isa      => 'NetHack::Item | Str',
    required => 1,
);

sub to_wield {
    my $self = shift;
    return $self->weapon->slot if blessed $self->weapon;
    return $self->weapon;
}

sub respond_wield_what { shift->to_wield }

sub done {
    my $self = shift;
    TAEB->inventory->wielded($self->weapon);
    # XXX: we need to track TAEB's offhand weapon too
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

