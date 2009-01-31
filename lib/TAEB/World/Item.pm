package TAEB::World::Item;
use TAEB::OO;
with 'MooseX::Role::Matcher' => { default_match => 'identity' };

has nhi => (
    is       => 'ro',
    isa      => 'NetHack::Item',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

