package TAEB::Debug::Profiler;
use TAEB::OO;
use TAEB::Util 'sum';

has profile => (
    metaclass => 'Collection::Hash',
    is        => 'ro',
    isa       => 'HashRef[Num]',
    default   => sub { {} },
    provides  => {
        keys   => 'profile_categories',
        get    => '_get_category_profile',
        set    => '_set_category_profile',
    },
);

has start => (
    is      => 'ro',
    isa     => 'Int',
    default => sub { time },
);

sub add_category_time {
    my $self     = shift;
    my $category = shift;
    my $time     = shift;

    my $existing = $self->_get_category_profile($category) || 0;
    $self->_set_category_profile($category => $existing + $time);
}

sub analyze {
    my $self = shift;
    my $profile = $self->profile;
    my $total_time = time - $self->start;

    my @results;
    for my $category (sort { $profile->{$b} <=> $profile->{$a} } keys %$profile) {
        push @results, [
            $category,
            $profile->{$category},
            $profile->{$category} / $total_time,
        ],
    }

    return @results;
}

__PACKAGE__->meta->make_immutable;

1;

