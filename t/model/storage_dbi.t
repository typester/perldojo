use strict;
use warnings;
use utf8;
use FindBin;

use Test::More;
use Test::mysqld;
use t::Utils;

use_ok 'Dojo::Model::Storage';
use_ok 'Dojo::Model::Storage::DBI';

my $mysqld = Test::mysqld->new(
    my_cnf => {
        'skip-networking' => '', # no TCP socket
    }
) or die $Test::mysqld::errstr;

my $dbh = DBI->connect( $mysqld->dsn( dbname => "test" ) );
$dbh->do( Dojo::Model::Storage::DBI->schema );

my $s = Dojo::Model::Storage->new(
    backend => Dojo::Model::Storage::DBI->new(
        connect_info => [ $mysqld->dsn( dbname => "test" ) ]
    ),
);
isa_ok $s, 'Dojo::Model::Storage';

subtest "result" => sub {
    is_deeply $s->set_result( foo => 1 ) => { answered => 1, corrected => 1 };
    is_deeply $s->set_result( foo => 0 ) => { answered => 2, corrected => 1 };
    is_deeply $s->set_result( foo => 1 ) => { answered => 3, corrected => 2 };
    is_deeply $s->set_result( foo => 0 ) => { answered => 4, corrected => 2 };
    is_deeply $s->set_result( foo => 1 ) => { answered => 5, corrected => 3 };
    is_deeply $s->set_result( bar => 1 ) => { answered => 1, corrected => 1 };
    is_deeply $s->set_result( bar => 1 ) => { answered => 2, corrected => 2 };
    is_deeply $s->set_result( bar => 0 ) => { answered => 3, corrected => 2 };

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
