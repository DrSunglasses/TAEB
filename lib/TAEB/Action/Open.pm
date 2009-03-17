package TAEB::Action::Open;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Direction';

use constant command => 'o';

has '+direction' => (
    required => 1,
);

subscribe door => sub {
    my $self  = shift;
    my $event = shift;

    my $status = $event->status;
    my $tile   = $event->door;

    if ($status eq 'locked') {
        $tile->state('locked');
    }
    elsif ($status eq 'resists') {
        $tile->state('unlocked');
    }
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

