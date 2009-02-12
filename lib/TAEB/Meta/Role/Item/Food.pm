package TAEB::Meta::Role::Item::Food;
use Moose::Role;
with 'TAEB::Meta::Role::Item';

sub is_safely_edible {
    my $self = shift;

    # Induces vomiting.
    return 0 if $self->identity eq 'tripe ration';

    return 1;
}

no Moose::Role;

1;
