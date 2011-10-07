package t::Utils;
use strict;
use warnings;
use Dojo;
use Test::mysqld;

use Exporter 'import';
our @EXPORT = qw/ setup_memcached setup_app /;
our @EXPORT_OK = @EXPORT;

sub setup_app (%) {
    my $args = shift || {};

    my $dojo = Dojo->new;
    $dojo->setup;

    my $memcached = setup_memcached();

    $dojo->config->{storage}->{backend}->{class} = "Cache::Memcached::Fast";
    $dojo->config->{storage}->{backend}->{args}->{servers}
        = [ "127.0.0.1:" . $memcached->port ];
    $dojo->config->{storage}->{__backend} = $memcached; # keep instance

    if ($args->{config}) {
        $dojo->config->{$_} = clone($args->{config}->{$_})
            for keys %{ $args->{config} };
    }

    sub { $dojo->handler->(@_) };
}

sub setup_memcached {
    require Test::TCP;
    my $bin = $ENV{MEMCACHED} || "memcached";
    my $memcached = Test::TCP->new(
        code => sub {
            my $port = shift;
            exec $bin, '-p' => $port;
            die "cannot execute $bin: $!";
        },
    );
    $memcached;
}

1;
