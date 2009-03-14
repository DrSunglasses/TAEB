package TAEB::Role::Subscription;
use Moose::Role;
use List::MoreUtils qw/any/;

requires 'initialize';
before initialize => sub {
    my $self = shift;

    # TAEB::Publisher defines send_message which is not what we want to
    # subscribe
    return if $self->isa('TAEB::Publisher');

    TAEB->publisher->subscribe($self)
        if $self->meta->has_method('send_message')
        || any { /^(?:msg|exception|respond)_/ } $self->meta->get_method_list;
};

no Moose::Role;

1;

