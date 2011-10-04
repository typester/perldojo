use strict;
use warnings;
use utf8;
use FindBin;

use Test::More;
use Test::TCP;

my $bin = $ENV{MEMCACHED} || "memcached";
my $memcached = Test::TCP->new(
    code => sub {
        my $port = shift;
        exec $bin, '-p' => $port;
        die "cannot execute $bin: $!";
    },
);
my $port = $memcached->port;
note "memcached port $port";

use_ok 'Dojo::Model::Storage';
use_ok 'Cache::Memcached::Fast';

my $s = Dojo::Model::Storage->new(
    backend => Cache::Memcached::Fast->new({ servers => ["127.0.0.1:$port"] }),
);
isa_ok $s, 'Dojo::Model::Storage';

subtest "result" => sub {
    $s->set_result( foo => 1 );
    $s->set_result( foo => 0 );
    $s->set_result( foo => 1 );
    $s->set_result( foo => 0 );
    $s->set_result( foo => 1 );
    $s->set_result( bar => 1 );
    $s->set_result( bar => 1 );
    $s->set_result( bar => 0 );

    my $foo = $s->get_result("foo");
    is_deeply $foo => { answered => 5, corrected => 3 }, "foo result";

    my $bar = $s->get_result("bar");
    is_deeply $bar => { answered => 3, corrected => 2 }, "foo result";

    my $no = $s->get_result("no");
    is_deeply $no => { answered => 0, corrected => 0 }, "foo result";
};

subtest "star" => sub {
    for ( 1 .. 100 ) {
        my $key = join("", map { chr( int rand(26) + 65 ) } (0.. ( 10 + rand(10) )));
        my $n = int rand(30);
        $s->add_star($key) for 1 .. $n;
        my $star = $s->get_star($key);

        is $star => $n, "star $key = $n";
    }
};

done_testing;
