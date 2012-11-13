package Mojolicious::Plugin::Config::Merge;
use 5.010;
use strict;
use warnings;

## no critic ( RegularExpressions::RequireExtendedFormatting )

use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Util 'decamelize';

use Module::Load;
use File::Spec::Functions 'file_name_is_absolute';

use Try::Tiny;

# VERSION


sub load_config {
	my ( $self, $path, $conf, $app ) = @_;

	$app->log->debug(qq{Reading config files in "$path".});

	my $mode = $app->mode;
	load 'Config::Merge';

	return Config::Merge->new(
		path     => $path,
		is_local => [ qr/^.*\.$mode/ ],
		skip     => [ qr/^(?:lib|bin|share|t|)$/, qr/^META/, qr/Makefile|Build/i ],
	);
}

sub register {
	my ( $self, $app, $conf ) = @_;

	# Config path
	my $path
		= defined $conf->{path}     ? $conf->{path}
		: defined $ENV{MOJO_CONFIG} ? $ENV{MOJO_CONFIG}
		: defined $ENV{MOJO_APP}    ? decamelize( $ENV{MOJO_APP} )
		:                             undef
		;

	$path =~ s/\.(?:pl|t)$//i if $path;

	# Absolute paths
	my $abs_path
		= file_name_is_absolute( $path ) ? $path
		: defined $path                  ? $app->home->rel_dir( $path )
		:                                  $app->home->to_string
		;

	my $config
		= try {
			$self->load_config( $abs_path, $conf, $app );
		}
		catch {
			load 'Carp';
			Carp::confess $_;
		};
}

1;

# ABSTRACT: Config::Merge configuration plugin for Mojolicious

=head1 SYNOPSIS

	use Mojolicious::Lite;

	my $config = plugin 'Config::Merge';

	my $val = $config->('confname.key.val');

=cut
