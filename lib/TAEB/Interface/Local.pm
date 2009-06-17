package TAEB::Interface::Local;
use TAEB::OO;
use IO::Pty::HalfDuplex;

extends 'TAEB::Interface';

has name => (
    is      => 'ro',
    isa     => 'Str',
    default => 'nethack',
);

has args => (
    is         => 'ro',
    isa        => 'ArrayRef[Str]',
    auto_deref => 1,
    default    => sub { [] },
);

has pty => (
    traits  => [qw/TAEB::Meta::Trait::DontInitialize/],
    is      => 'ro',
    isa     => 'IO::Pty::HalfDuplex',
    lazy    => 1,
    handles => ['is_active'],
    builder => '_build_pty',
);

sub _build_pty {
    my $self = shift;

    chomp(my $pwd = `pwd`);

    my $rcfile = TAEB->config->taebdir_file('nethackrc');

    # Always rewrite the rcfile, in case we've updated it. We may want to
    # compare checksums instead, but whatever, we can worry about that later.
    open my $fh, '>', $rcfile or die "Unable to open $rcfile for writing: $!";
    $fh->write(TAEB->config->nethackrc_contents);
    close $fh;

    local $ENV{NETHACKOPTIONS} = '@' . $rcfile;
    local $ENV{TERM} = 'xterm-color';

    # TAEB requires 80x24
    local $ENV{LINES} = 24;
    local $ENV{COLUMNS} = 80;

    # set Pty to ignore SIGWINCH so that we don't confuse nethack if
    # controlling terminal is not set to 80x24
    my $pty = IO::Pty::HalfDuplex->new(handle_pty_size => 0);

    $pty->spawn($self->name, $self->args);
    return $pty;
}

augment read => sub {
    my $self = shift;

    die "Pty inactive" unless $self->is_active;

    # We already waited for output to arrive; don't wait even longer if there
    # isn't any. Use an appropriate reading function depending on the class.
    return $self->pty->recv;
};

sub flush { shift->pty->recv }

augment write => sub {
    my $self = shift;

    die "Pty inactive" unless $self->is_active;

    return $self->pty->write((join '', @_), 1);
};

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

TAEB::Interface::Local - how TAEB talks to a local nethack

=head1 METHODS

=head2 read -> STRING

This will read from the pty. It will die if an error occurs.

It will return the input read from the pty.

=head2 flush

When using HalfDuplex, we have to do a recv in order to send data.
If flush is being called, it means that the return value can be
safely ignored.

=head2 write STRING

This will write to the pty. It will die if an error occurs.

=head1 SEE ALSO

L<http://taeb-blog.sartak.org/2009/06/synchronizing-with-nethack.html>

=cut

