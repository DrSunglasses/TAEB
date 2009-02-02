# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'TAEB';
all_from       'lib/TAEB.pm';

# the object system
requires 'Moose';
requires 'MooseX::Singleton' => 0.14;
requires 'MooseX::AttributeHelpers' => 0.09;
requires 'MooseX::ClassAttribute' => 0.07;
requires 'MooseX::Role::Matcher' => 0.03;
requires 'Module::Pluggable';

# parse escape codes into an addressable screen
requires 'Term::VT102::ZeroBased';

# print on an addressable screen
requires 'Curses';

# logging
requires 'Log::Dispatch::Channels';

# config
requires 'YAML';
requires 'Hash::Merge';

# TAEB::Util
requires 'Sub::Exporter';
requires 'List::MoreUtils';

# pathfinding
requires 'Heap::Simple';
requires 'Heap::Simple::XS'; # why doesn't Heap::Simple do this for us >_<

# miscellaneous
requires 'Time::HiRes';

# NetHack-specific things
requires 'NetHack::Menu' => 0.05;
requires 'NetHack::FOV';
requires 'NetHack::Item' => 0.06;

features(
    # optional modules that enhance TAEB's playing
    'TAEB for server NetHack' => [
        -default => 0,
        recommends('IO::Socket::Telnet'),
    ],
    'TAEB for local NetHack' => [
        -default => 0,
        recommends('IO::Pty::Easy'),
    ],

    # debugging tools
    'REPL on exception' => [
        -default => 1,
        recommends('Carp::REPL'),
    ],
    'REPL on ~' => [
        -default => 1,
        recommends('Devel::REPL'),
        recommends('Term::ReadLine::Gnu'),
    ],
    'IRC debug interface' => [
        -default => 0,
        recommends('Bot::BasicBot'),
        recommends('App::Nopaste'),
    ],
    'Log errors (and eventually deaths) to Twitter' => [
        -default => 0,
        recommends('Log::Dispatch::Twitter'),
    ],
);

build_requires 'Test::More';

install_script 'bin/taeb';

tests('t/*.t t/*/*.t');

auto_install;
WriteAll;

