package TAEB::Role::Initialize;
use Moose::Role;

sub initialize { }
after initialize => sub {
    my $self = shift;

    my @attrs = $self->meta->get_all_attributes;
    push @attrs, $self->meta->get_all_class_attributes
        if $self->meta->can('get_all_class_attributes');

    for my $attr (@attrs) {
        next if $attr->is_weak_ref;

        my $reader = $attr->get_read_method_ref;
        my $value  = $reader->($self);
        next unless blessed($value);

        my $meta = Class::MOP::Class->initialize(blessed $value);
        if ($meta && $meta->can('does_role') && $meta->does_role(__PACKAGE__)) {
            $value->initialize;
        }
    }
};

no Moose::Role;

1;

