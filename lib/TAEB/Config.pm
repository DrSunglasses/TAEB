package TAEB::Config;
use Moose;
use YAML;
use Hash::Merge 'merge';
Hash::Merge::set_behavior('RIGHT_PRECEDENT');

use File::Spec;
use File::HomeDir;

$ENV{TAEBDIR} ||= do {
    File::Spec->catdir(File::HomeDir->my_home, '.taeb');
};

-d $ENV{TAEBDIR} or do {
    $SIG{__DIE__} = 'DEFAULT';
    die "Please create a $ENV{TAEBDIR} directory.\n";
};

sub taebdir_file {
    my $self = shift;
    File::Spec->catfile($ENV{TAEBDIR}, @_),
}

has file => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my @locations = (
            shift->taebdir_file('config.yml'),
            'etc/config.yml',
        );

        -e $_ and return $_ for @locations;

        $SIG{__DIE__} = 'DEFAULT';
        die "Could not find a config file. You should copy TAEB's etc/config.yml into $ENV{TAEBDIR}/config.yml!";
    },
);

has contents => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

sub BUILD {
    my $self = shift;

    my @config = $self->file;

    my %seen;

    while (my $file = shift @config) {
        next if $seen{$file}++;

        my $config = YAML::LoadFile($file);
        $self->contents(merge($self->contents, $config));

        # if this config specified other files, load them too
        if ($config->{other_config}) {
            my $c = $config->{other_config};
            my @new_files;
            if (ref($c) eq 'ARRAY') {
                @new_files = @$c;
            }
            elsif (ref($c) eq 'HASH') {
                @new_files = keys %$c;
            }
            else {
                @new_files = ($c);
            }
            push @config, map {
                s{^~(\w+)}{File::HomeDir->users_home($1)}e;
                s{^~}{File::HomeDir->my_home}e;
                File::Spec->file_name_is_absolute($_)
                    ? $_
                    : File::Spec->catfile($ENV{TAEBDIR}, $_);
            } @new_files;
        }
    }
}

=head2 get_role

Retrieves the role from the config, or picks randomly.

=cut

sub get_role {
    my $self = shift;
    return '*' unless $self->character;
    my $role = $self->character->{role}
        or return '*';
    return $1
        if lc($role) =~ /^([abchkmpstvw])/;
    return 'r'
        if $role =~ /^R[^a]/ || $role eq 'r';
    return 'R'
        if $role =~ /^Ra/i || $role eq 'R';
    return '*';
}

=head2 get_race

Retrieves the race from the config, or picks randomly.

=cut

sub get_race {
    my $self = shift;
    return '*' unless $self->character;
    my $role = $self->character->{race}
        or return '*';
    return $1
        if lc($role) =~ /^([hedgo])/;
    return '*';
}

=head2 get_gender

Retrieves the gender from the config, or picks randomly.

=cut

sub get_gender {
    my $self = shift;
    return '*' unless $self->character;
    my $role = $self->character->{gender}
        or return '*';
    return $1
        if lc($role) =~ /^([mf])/;
    return '*';
}

=head2 get_align

Retrieves the alignment from the config, or picks randomly.

=cut

sub get_align {
    my $self = shift;
    return '*' unless $self->character;
    my $role = $self->character->{align} || $self->character->{alignment}
        or return '*';
    return $1
        if lc($role) =~ /^([lnc])/;
    return '*';
}

=head2 get_ai

=cut

sub get_ai {
    my $self = shift;

    my $ai_class = $self->ai
        or die "Specify a class for 'ai' in your config";

    Class::MOP::load_class($ai_class);
    return $ai_class->new;
}

=head2 get_interface

=cut

sub get_interface {
    my $self = shift;

    my $interface = $self->interface
        or die "Specify a class for 'interface' in your config";

    my $interface_class = $interface =~ s/^\+//
                        ? $interface
                        : "TAEB::Interface::$interface";

    Class::MOP::load_class($interface_class);

    my %interface_options;
    %interface_options = %{ $self->interface_options->{$interface} || {} }
        if defined $self->interface_options;
    return $interface_class->new(%interface_options);
}

# yes autoload is bad. but, I am lazy
our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    $AUTOLOAD =~ s{.*::}{};

    if (@_) {
        TAEB->config->contents->{$AUTOLOAD} = shift;
    }

    return TAEB->config->contents->{$AUTOLOAD};
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

