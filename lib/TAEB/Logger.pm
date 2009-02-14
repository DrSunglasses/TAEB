use strict;
use warnings;
package TAEB::Logger;
use TAEB::OO;
use Log::Dispatch::Twitter;
use Log::Dispatch::File;
use Carp;
extends 'Log::Dispatch::Channels';

has default_outputs => (
    isa     => 'ArrayRef[Log::Dispatch::Output]',
    lazy    => 1,
    default => sub { [] },
);

has bt_levels => (
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { { error => 1, warning => 1 } },
);

has everything => (
    isa     => 'Log::Dispatch::File',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $output = Log::Dispatch::File->new(
            name      => 'everything',
            min_level => $self->_default_min_level,
            filename  => logfile_for("everything"),
            callbacks => sub { $self->_format(@_) },
        );
        $self->add_as_default($output);
        return $output;
    },
);

has warning => (
    isa     => 'Log::Dispatch::File',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $output = Log::Dispatch::File->new(
            name      => 'warning',
            min_level => 'warning',
            filename  => logfile_for("warning"),
            callbacks => sub { $self->_format(@_) },
        );
        $self->add_as_default($output);
        return $output;
    },
);

has error => (
    isa     => 'Log::Dispatch::File',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $output = Log::Dispatch::File->new(
            name      => 'error',
            min_level => 'error',
            filename  => logfile_for("error"),
            callbacks => sub { $self->_format(@_) },
        );
        $self->add_as_default($output);
        return $output;
    },
);

has twitter => (
    isa     => 'Maybe[Log::Dispatch::Twitter]',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return unless $self->config;
        my $error_config = $self->config->{twitter}{errors};
        return unless $error_config;
        require Log::Dispatch::Twitter;
        my $twitter = Log::Dispatch::Twitter->new(
            name      => 'twitter',
            min_level => 'error',
            username  => $error_config->{username},
            password  => $error_config->{password},
            callbacks => sub {
                my %args = @_;
                return if $args{message} =~ /^Game over/;

                # XXX: we need to not throw errors when we die
                return if $args{message} =~ /^Unable to parse the (botl|status)/;

                $args{message} =~ s/\n.*//s;
                return sprintf "%s (T%s): %s",
                            TAEB->loaded_persistent_data
                          ? (TAEB->name, TAEB->turn)
                          : ('?',        '-'       ),
                            $args{message};
            },
        );
        $self->add_as_default($twitter);
        return $twitter;
    },
);

around new => sub {
    my $orig = shift;
    my $self = $orig->(@_);
    # we don't initialize log files until they're used, so need to make sure
    # old ones don't stick around
    unlink for (glob "log/*.log");
    $self->everything;
    $self->warning;
    $self->error;
    $self->twitter;
    return $self;
};

around twitter => sub {
    my $orig = shift;
    my $self = shift;
    my $output = $self->$orig();
    return $output unless @_;
    my $message = shift;
    $output->log(level => 'error', message => $message, @_);
};

around [qw/everything warning error/] => sub {
    my $orig = shift;
    my $self = shift;
    die "Don't log directly to the catch-all loggers" if @_;
    return $self->$orig();
};

after add_channel => sub {
    my $self = shift;
    my $channel_name = shift;

    for my $output (@{ $self->default_outputs }) {
        $self->channel($channel_name)->add($output);
    }
};

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my $message = shift;
    my $channel_name = $AUTOLOAD;
    $channel_name =~ s/.*:://;
    return if $channel_name =~ /^[A-Z_]+$/;
    my $channel = $self->channel($channel_name);
    if (!$channel) {
        # XXX: would be nice if LDC had global callbacks
        $self->add_channel($channel_name,
                           callbacks => [
                           sub {
                               my %args = @_;
                               if ($self->bt_levels->{$args{level}}) {
                                   return Carp::longmess($args{message});
                               }
                               else {
                                   return $args{message};
                               }
                           },
                           sub {
                               my %args = @_;
                               return sprintf "[%s:%s] %s",
                                              uc($args{level}),
                                              $channel_name,
                                              $args{message};
                           },
                           ]);
        $self->add(Log::Dispatch::File->new(
                       name      => $channel_name,
                       min_level => $self->_default_min_level,
                       filename  => logfile_for($channel_name),
                       callbacks => sub { $self->_format(@_) },
                   ),
                   channels => $channel_name);
    }
    $self->log(channels => $channel_name,
               level    => 'debug',
               message  => $message,
               @_);
}

sub add_as_default {
    my $self = shift;
    my $output = shift;

    $self->add($output);
    push @{ $self->default_outputs }, $output;
}

sub _format {
    my $self = shift;
    my %args = @_;

    chomp $args{message};

    my ($sec, $min, $hour, $mday, $mon, $year) = localtime;

    return sprintf "<T%s> %04d-%02d-%02d %02d:%02d:%02d %s\n",
                   (TAEB->loaded_persistent_data ? TAEB->turn : '-'),
                   $year + 1900,
                   $mon + 1,
                   $mday,
                   $hour,
                   $min,
                   $sec,
                   $args{message};
}

sub _default_min_level {
    my $self = shift;
    my $log_config = TAEB->config->logger;
    return 'debug' unless defined $log_config
                       && exists  $log_config->{min_level};
    return $log_config->{min_level};
}

sub logfile_for {
    my $channel = shift;

    # if we can't open or create the logdir, then just put logs into the current
    # directory :/
    my $logdir = TAEB->config->taebdir_file("log");
    if (!-d $logdir && !mkdir($logdir)) {
        warn "Please make a writable $logdir log directory!";
        return "TAEB-$channel.log";
    }

    TAEB->config->taebdir_file("log", "$channel.log");
}

# we need to use Log::Dispatch::Channels' constructor
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
no Moose;

1;
