package TAEB::Announcement::Character::FinallyFinished;
use TAEB::OO;
extends 'TAEB::Announcement::Character';

use constant name => 'finally_finished';

__PACKAGE__->parse_messages(
    qr/^You're finally finished\./ => {},
);

__PACKAGE__->meta->make_immutable;

1;
