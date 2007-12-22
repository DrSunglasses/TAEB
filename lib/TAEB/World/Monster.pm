#!/usr/bin/env perl
package TAEB::World::Monster;
use Moose;
use String::Koremutake;

has id => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my $k = String::Koremutake->new;
        return $k->integer_to_string(int(rand(1000000)));
    },
);

has name => (
  is  => 'rw',
  isa => 'Str',
);

has ac => (
  is  => 'rw',
  isa => 'Int',
);

has mr => (
  is  => 'rw',
  isa => 'Int',
);

has level => (
  is  => 'rw',
  isa => 'Int',
);

has speed => (
  is  => 'rw',
  isa => 'Int',
);

has elbereth => (
  is            => 'rw',
  isa           => 'Bool',
  default       => 1,
  documentation => "whether the monster respects Elbereth",
);

has 'glyph' => (
  is  => 'rw',
  isa => 'Str',
);

has 'color' => (
  is  => 'rw',
  isa => 'Str',
);

1;

