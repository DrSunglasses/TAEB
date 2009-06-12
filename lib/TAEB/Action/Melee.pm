package TAEB::Action::Melee;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Direction';
with 'TAEB::Action::Role::Monster';

has '+direction' => (
    required => 1,
);

# sadly, Melee doesn't give an "In what direction?" message
sub command { 'F' . shift->direction }

__PACKAGE__->meta->make_immutable;

1;


