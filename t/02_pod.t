use strict;
use warnings;
use Test::More;

my $tp_ver = 1.22;
eval "use Test::Pod $tp_ver";
plan skip_all => "Test::Pod $tp_ver required for testing POD" if $@;

my @poddirs = qw/blib/;
all_pod_files_ok(all_pod_files(@poddirs));
