package TAEB::OO;
use Moose ();
use MooseX::ClassAttribute ();
use Moose::Exporter;
use Moose::Util::MetaRole;

use TAEB::Meta::Class;
use TAEB::Meta::Trait::Persistent;
use TAEB::Meta::Trait::GoodStatus;
use TAEB::Meta::Types;
use TAEB::Meta::Overload;

Moose::Exporter->setup_import_methods(
    also => ['Moose', 'MooseX::ClassAttribute'],
);

sub init_meta {
    shift;
    my %options = @_;
    Moose->init_meta(%options, metaclass => 'TAEB::Meta::Class');
    Moose::Util::MetaRole::apply_metaclass_roles(
        for_class                 => $options{for_class},
        attribute_metaclass_roles => ['TAEB::Meta::Role::Provided'],
    ) if $options{for_class} =~ /^TAEB::Action/;
    return $options{for_class}->meta;
}

1;

