package TAEB::Debug::Sanity;
use TAEB::OO;
with 'TAEB::Role::Config';

sub msg_step {
    my $self = shift;

    TAEB->enqueue_message('sanity');
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
