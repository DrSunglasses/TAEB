#!/usr/bin/env perl
package TAEB::World::Item::Gold;
use Moose;
extends 'TAEB::World::Item';

has '+class' => (
    default => 'gold',
);

make_immutable;

1;

