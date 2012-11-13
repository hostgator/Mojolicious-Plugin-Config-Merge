use strict;
use warnings;
use Test::More;
use Mojolicious::Lite;
use Data::Dumper::Concise;

my $config = plugin 'Config::Merge';

isa_ok $config, 'Config::Merge';

is $config->('db.username'), 'foo' , 'db username';
is $config->('db.password'), 'bar' , 'db password';
is $config->('db.dsn'     ), 'test', 'db dsn';

done_testing;
