use strict;
use warnings;
use Test::More;
use Mojolicious::Lite;
use Data::Dumper::Concise;

my $config = plugin 'Config::Merge';

isa_ok $config, 'Config::Merge';

done_testing;
