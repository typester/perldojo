# -*- mode:perl -*-
use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use t::Utils;

my $app = setup_app;

test_psgi $app, sub {
   my $cb = shift;

   subtest ping => sub {
       my $res = $cb->( GET "http://localhost/api/ping" );
       is $res->code, 200;
       is $res->content => "ok";
   };
};

done_testing;
