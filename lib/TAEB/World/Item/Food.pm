package TAEB::World::Item::Food;
use TAEB::OO;
extends 'TAEB::World::Item';

has '+nhi' => (
    isa     => 'NetHack::Item::Food',
    handles => [qw/is_partly_eaten is_laid_by_you nutrition time/],
);

sub is_safely_edible {
    my $self = shift;

    # Induces vomiting.
    return 0 if $self->identity eq 'tripe ration';

    return 1;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

