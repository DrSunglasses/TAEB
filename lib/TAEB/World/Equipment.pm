package TAEB::World::Equipment;
use TAEB::OO;
extends 'NetHack::Inventory::Equipment';

use overload %TAEB::Meta::Overload::default;

sub debug_line {
    my $self = shift;
    my @eq;

    for my $attr (__PACKAGE__->meta->get_all_attributes) {
        next if $attr->name eq 'pool'; # Not actually equipment!

        my $item = $attr->get_value($self);
        push @eq, $attr->name . ': ' . $item->debug_line
            if $item;
    }

    return join "\n", @eq;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

