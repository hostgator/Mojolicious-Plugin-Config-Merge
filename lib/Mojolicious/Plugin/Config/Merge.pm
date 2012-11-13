package Mojolicious::Plugin::Config::Merge;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT:

=head1 SYNOPSIS

	use Mojolicious::Plugin::Config::Merge;

	my $obj = Mojolicious::Plugin::Config::Merge->new;

=cut
