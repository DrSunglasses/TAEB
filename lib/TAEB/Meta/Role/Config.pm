#!/usr/bin/perl
package TAEB::Meta::Role::Config;
use Moose::Role;

has config => (
    isa => 'Maybe[HashRef]',
    lazy => 1,
    default => sub {
        my ($self, $attr_meta) = @_;
        my $class = $attr_meta->associated_class;
        $class =~ s/^TAEB:://;
        my @config_path = split /::/, $class;
        my $config = TAEB->config->contents;
        for (@config_path) {
            if ($config) {
                $config = $config->{lc($_)};
            }
            else {
                return;
            }
        }
        return $config;
    },
);

no Moose::Role;

1;
