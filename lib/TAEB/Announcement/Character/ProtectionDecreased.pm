package TAEB::Announcement::Character::ProtectionDecreased;
use TAEB::OO;
extends 'TAEB::Announcement::Character';

use constant name => 'protection_dec';

__PACKAGE__->parse_messages(
    'The golden haze around you becomes less dense.' => {},
);

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;
