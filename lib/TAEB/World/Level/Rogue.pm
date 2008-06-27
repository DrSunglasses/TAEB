#!/usr/bin/env perl
package TAEB::World::Level::Rogue;
use TAEB::OO;
extends 'TAEB::World::Level';

__PACKAGE__->meta->add_method("is_$_" => sub { 0 })
    for (grep { $_ ne 'rogue' } @TAEB::World::Level::special_levels);

sub is_rogue { 1 }

=head2 glyph_to_type str[, str] -> str

This will look up the given glyph (and if given color) and return a tile type
for it. Note that monsters and items (and any other miss) will return
"obscured".

=cut

sub glyph_to_type {
    my $self  = shift;
    my $glyph = shift;

    return $TAEB::Util::rogue_glyphs{$glyph} || 'obscured';
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
