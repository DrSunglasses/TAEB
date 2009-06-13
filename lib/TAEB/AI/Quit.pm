package TAEB::AI::Quit;
use TAEB::OO;
extends 'TAEB::AI';

sub next_action { TAEB::Action::Quit->new }

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

__END__

=head1 NAME

TAEB::AI::Quit - I just can't take it any more...

=cut

