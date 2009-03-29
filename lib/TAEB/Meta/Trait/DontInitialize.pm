package TAEB::Meta::Trait::DontInitialize;
use Moose::Role;

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::TAEB::DontInitialize;
sub register_implementation { 'TAEB::Meta::Trait::DontInitialize' }

1;
