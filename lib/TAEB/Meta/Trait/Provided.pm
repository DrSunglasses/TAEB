package TAEB::Meta::Trait::Provided;
use Moose::Role;

has provided => (
    is      => 'rw',
    isa     => 'Bool',
    default => 1,
);

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::TAEB::Provided;
sub register_implementation { 'TAEB::Meta::Trait::Provided' }

1;

__END__

=head1 NAME

TAEB::Meta::Trait::Provided - this action attribute is provided

=head1 DESCRIPTION

Attributes with the C<provided> option are to be provided by the AI. This
tagging is useful to L<TAEB::AI::WebHack>.

Not all action attributes are provided. For example, many of
L<TAEB::Action::Throw>'s attributes are not provided, but calculated or by
messages for bookkeeping.

We don't use C<required> because we provide default values for many
attributes that should be provided. Someone not familiar with the WebHack AI
will probably think the C<required> and C<default> options provided together
are redundant.

There could also be C<provided> attributes that aren't C<required>.

Finally, C<provided> is another meta-attribute and not just an empty role
because L<TAEB::Action::Role::Direction> assumes the direction is provided,
but the L<TAEB::Action::Ascend> action turns off providedness, since it's
always C<< < >>.

=cut

