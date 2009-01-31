package TAEB::World::Item;
use TAEB::OO;
with 'MooseX::Role::Matcher' => { default_match => 'identity' };

has nhi => (
    is       => 'ro',
    isa      => 'NetHack::Item',
    required => 1,
    handles  => {
        map { $_ => $_ } qw/
            appearance artifact buc has_appearance has_identity identity
            incorporate_stats_from is_artifact is_blessed is_cursed
            is_evolution_of is_holy is_offhand is_quivered is_uncursed
            is_unholy is_wielded maybe_is quantity raw slot spoiler_values
            subtype type
        /,
    },
);

sub new_item {
    my $self = shift;

    my $nhi = NetHack::Item->new(@_);
    my $nhi_subclass = $nhi->meta->name;

    (my $subclass = $nhi_subclass) =~ s/^NetHack/TAEB::World/;

    return $subclass->new(nhi => $nhi);
}

sub is_auto_picked_up {
    my $self = shift;
    return 0 if !TAEB->autopickup;

    return 1 if $self->match(identity => 'gold piece')
             || $self->match(type => 'wand');

    return 0;
}

# we try to uphold this API
sub isa {
    my $self = shift;

    return 1 if $_[0] eq 'NetHack::Item';

    $self->SUPER::isa(@_);
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;

