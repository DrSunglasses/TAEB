package TAEB::Role::Subscription;
use Moose::Role;
use List::MoreUtils qw/any/;

requires 'initialize';
before initialize => sub {
    my $self = shift;

    TAEB->publisher->subscribe($self)
        if $self->meta->has_method('forward_message')
        || (any { /^(?:msg|exception|respond)_/ } $self->meta->get_method_list)
        || (any { /^(?:subscription)_/ } $self->meta->get_method_list);
};

no Moose::Role;

1;

