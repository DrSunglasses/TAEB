package TAEB::Announcement;
use TAEB::OO;

use Module::Pluggable (
    require     => 1,
    sub_name    => 'announcement_classes',
    search_path => ['TAEB::Announcement'],
);
__PACKAGE__->announcement_classes;

has text => (
    is            => 'ro',
    isa           => 'Str',
    predicate     => 'has_text',
    documentation => 'The text sent by NetHack that generated this message.',
);

# default name for TAEB::Announcement::Foo::Bar is foo_bar
sub name {
    my $self = shift;
    my $class = blessed($self) || $self;

    $class =~ s/^TAEB::Announcement:://;
    $class =~ s/::/_/g;

    return lc $class;
}

do {
    my %name_to_class;

    sub set_name_to_class {
        my $self = shift;
        my $name = shift;
        my $class = shift;

        if (exists $name_to_class{$name}) {
            confess "Two announcement classes conflict over the same name '$name': $class and $name_to_class{$name}";
        }

        $name_to_class{$name} = $class;
    }

    sub name_to_class {
        my $self = shift;
        my $name = shift;

        return $name_to_class{$name} if exists $name_to_class{$name};
        confess "No announcement class with the name '$name' exists.";
    }
};

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

