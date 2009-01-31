package TAEB::World;
use strict;
use warnings;

use Module::Pluggable (
    require     => 1,
    sub_name    => 'load_world_classes',
    search_path => ['TAEB::World'],
);

__PACKAGE__->load_world_classes;

1;

