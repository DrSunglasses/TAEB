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

sub _get_controller_class {
    my $self = shift;
    my ($controller) = @_;
    my $controller_config = lc($controller);

    my $controller_class = $self->$controller_config
        or die "Specify a class for '$controller_config' in your config";
    $controller_class = $controller_class =~ s/^\+//
                      ? $controller_class
                      : "TAEB::$controller::$controller_class";

    Class::MOP::load_class($controller_class);

    return $controller_class;
}

sub _get_controller_config {
    my $self = shift;
    my ($controller, $controller_class) = @_;
    my $controller_config = lc($controller);

    my $options = $self->contents->{"${controller_config}_options"};
    return unless $options;

    $controller_class ||= caller;
    $controller_class = $self->get_controller_class
        if $controller_class !~ /^TAEB::${controller}::/;

    my $controller_class_config = $controller_class;
    $controller_class_config =~ s/^TAEB::${controller}::(.*?)::.*/$1/;
    $controller_class_config = lc($controller_class_config);

    return $options->{$controller_class_config};
}

sub get_ai_class         { shift->_get_controller_class('AI')         }
sub get_interface_class  { shift->_get_controller_class('Interface')  }
sub get_display_class    { shift->_get_controller_class('Display')    }
sub get_ai_config        { shift->_get_controller_config('AI')        }
sub get_interface_config { shift->_get_controller_config('Interface') }
sub get_display_config   { shift->_get_controller_config('Display')   }

sub nethackrc_contents {
    local $/;
    return <DATA>;
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
no TAEB::OO;

1;

__DATA__
# improve the consistency of telnet ping/pong
OPTIONS=!sparkle
OPTIONS=runmode:teleport
OPTIONS=!timed_delay

# display
OPTIONS=showexp
OPTIONS=showscore
OPTIONS=time
OPTIONS=color
OPTIONS=boulder:0
OPTIONS=!tombstone
OPTIONS=!news
OPTIONS=!legacy
OPTIONS=suppress_alert:3.4.3
OPTIONS=hilite_pet

# functionality
OPTIONS=autopickup
OPTIONS=pickup_types:$/
OPTIONS=pickup_burden:unburdened
OPTIONS=!prayconfirm
OPTIONS=pettype:none
OPTIONS=!cmdassist
OPTIONS=disclose:+iavgc

# miscellaneous
OPTIONS=!mail

# map changes for code simplicity
OPTIONS=monsters:abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@X'&;:wm
# "strange monster" = m (mimic)
# ghost/shade = X     now space is solid rock
# worm tail = w       now ~ is water

OPTIONS=traps:\^\^\^\^\^\^\^\^\^\^\^\^\^\^\^\^\^\^\^\^\^
# spider web = ^      now " is amulet

OPTIONS=dungeon: |--------||.-|]]}}.##<><>_\\\\{{~.}..}} #}
#  sink => {          one less #, walkable
#  drawbridge => }    one less #, not walkable
#  iron bars => }     one less #, not walkable (color: cyan)
#  trees => }         one less #, not walkable (color: green)
#  closed doors => ]  now + is spellbook
#  grave => \         now gray | and - are walls, (grey -- thrones)
#  water => ~         it looks cool (blue -- long worm tail)

OPTIONS=objects:m
# "strange object" = m (mimic)
# now ] is closed door
