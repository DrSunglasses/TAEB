package TAEB::Test::Monsters;
use TAEB::Test;
use TAEB::Util 'sum';

sub import {
    my $self = shift;
    return if @_ == 0;

    main->import('Test::More');

    plan_tests(@_);
    test_monsters(@_);
}

1;

