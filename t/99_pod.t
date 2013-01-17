use strict;
use warnings;
use Test::Pod;

my @poddirs = qw/blib/;
all_pod_files_ok(all_pod_files(@poddirs));
