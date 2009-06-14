package TAEB::Interface;
use TAEB::OO;

has read_iterations => (
    is      => 'ro',
    isa     => 'Int',
    default => 1,
);

sub read {
    my $self = shift;

    my $input = join '',
                map { my $output = inner(); defined $output ? $output : '' }
                1 .. $self->read_iterations;
    TAEB->log->log_to_channel(input => "Received '$input' from NetHack.");
    return $input;
}

sub write {
    my $self = shift;
    my $text = join '', @_;

    return if !defined($text) || length($text) == 0;

    TAEB->log->log_to_channel(output => "Sending '$text' to NetHack.");

    inner();
}

sub flush { }

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

__END__

=head1 NAME

TAEB::Interface - how TAEB talks to NetHack

=head1 METHODS

=head2 read -> STRING

This will read from the interface. It's quite OK to block and throw errors
in this method.

It should just return the string read from the interface.

Your subclass B<must> override this method.

=head2 write STRING, STRING, ...

This will write to the interface. It's quite OK to block and throw errors
in this method. Your subclass will receive potentially many strings as
arguments, it's vital to handle all of them
(by joining them together with C<join ''>)

Its return value is currently ignored.

Your subclass B<must> override this method.

=head2 flush

This causes a call to write() to take effect, if for some reason your
interface delays writes until the corresponding read. You can leave
this un-overriden if it would be a no-op. It's allowed to discard any
data it would otherwise read; this is for the purpose of ensuring that
the data is sent during emergency cleanup.

=cut

