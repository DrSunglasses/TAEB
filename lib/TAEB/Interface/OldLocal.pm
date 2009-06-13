package TAEB::Interface::OldLocal;
use TAEB::OO;
use Time::HiRes 'sleep';

use constant ping_wait => 0.2;

=head1 NAME

TAEB::Interface::OldLocal - Legacy IO::Pty::Easy interface

=cut

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

has pty_type => (
    is      => 'ro',
    isa     => 'Str',
    default => 'Easy',
);

has pty => (
    traits  => [qw/TAEB::Meta::Trait::DontInitialize/],
    is      => 'ro',
    isa     => 'TAEB::Type::Pty',
    lazy    => 1,
    handles => ['is_active'],
    builder => '_build_pty',
);

sub pty_class {
    my $self = shift;
    my $class = $self->pty_type;
    return $class if $class =~ s/^\+//;
    return "IO::Pty::$class";
}

sub _build_pty {
    my $self = shift;

    Class::MOP::load_class($self->pty_class);

    chomp(my $pwd = `pwd`);

    my $rcfile = TAEB->config->taebdir_file('nethackrc');
    unless (-e $rcfile) {
        open my $fh, '>', $rcfile or die "Unable to open $rcfile for writing: $!";
        $fh->write(TAEB->config->nethackrc_contents);
        close $fh;
    }

    local $ENV{NETHACKOPTIONS} = '@' . $rcfile;
    local $ENV{TERM} = 'xterm-color';

    # TAEB requires 80x24
    local $ENV{LINES} = 24;
    local $ENV{COLUMNS} = 80;

    # this has to be done in BUILD because it needs name

    # set Pty to ignore SIGWINCH so that we don't confuse nethack if
    # controlling terminal is not set to 80x24
    my $pty = $self->pty_class->new(handle_pty_size => 0);

    $pty->spawn($self->name, $self->args);
    return $pty;
}

=head2 read -> STRING

This will read from the pty. It will die if an error occurs.

It will return the input read from the pty.

=cut

augment read => sub {
    my $self = shift;

    # this is about the best we can do for consistency using Easy
    # in Telnet we have a complicated ping/pong that scales with network latency
    # alternatively you can use HalfDuplex to use a job-control-based ping wait
    # which scales with NetHack's drawing time
    sleep($self->ping_wait);

    die "Pty inactive" unless $self->is_active;
    # We already waited for output to arrive; don't wait even longer if there
    # isn't any. Use an appropriate reading function depending on the class.
    my $out = $self->pty->read(0,1024); }
    return '' if !defined($out);

    # We specified blocks of 1024 characters above. If we got exactly 1024,
    # read more.
    if (length($out) == 1024) {
        return $out . $self->read(@_);
    }

    return $out;
};

=head2 write STRING

This will write to the pty. It will die if an error occurs.

=cut

augment write => sub {
    my $self = shift;
    my $text = shift;

    die "Pty inactive" unless $self->is_active;
    my $chars = $self->pty->write($text, 1);
    return if !defined($chars);

    # An IPE counts the number of chars written; an IPH doesn't,
    # because writes are delayed-action in such a case.
    die "Pty closed" if $chars == 0;
    return $chars;
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

