package TAEB::Debug::Sanity;
use TAEB::OO;
with 'TAEB::Role::Config';

sub msg_step {
    my $self = shift;

    TAEB->enqueue_message('sanity');
}

#XXX
#sub msg_key {
#    my $self = shift;
#    my $key = shift;
#    return unless $key eq '~';
#
#    # Term::ReadLine seems to fall over on $ENV{PERL_RL} = undef?
#    $ENV{PERL_RL} ||= $self->config->{readline}
#        if $self->config && exists $self->config->{readline};
#
#    TAEB->display->deinitialize;
#
#    print "\n"
#        . "\e[1;37m+"
#        . "\e[1;30m" . ('-' x 50)
#        . "\e[1;37m[ "
#        . "\e[1;36mT\e[0;36mAEB \e[1;36mC\e[0;36monsole"
#        . " \e[1;37m]"
#        . "\e[1;30m" . ('-' x 12)
#        . "\e[1;37m+"
#        . "\e[m\n";
#
#    no warnings 'redefine';
#    require Devel::REPL::Script;
#
#    eval {
#        local $SIG{__WARN__};
#        local $SIG{__DIE__};
#        local $SIG{INT} = sub { die "Interrupted." };
#        Devel::REPL::Script->new->run;
#    };
#
#    TAEB->display->reinitialize;
#}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
