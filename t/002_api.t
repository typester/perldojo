# -*- mode:perl -*-
use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use t::Utils;
use Path::Class qw/ file dir /;

my $app = setup_app;
my $pod = [ grep { !$_->is_dir } dir("data")->children ]->[0];
(my $name = $pod->basename) =~ s/\.pod$//;
note "test pod: $pod";

test_psgi $app, sub {
   my $cb = shift;

   subtest ping => sub {
       my $res = $cb->( GET "http://localhost/api/ping" );
       is $res->code, 200;
       is $res->content => "ok";
   };

   subtest star_404 => sub {
       my $res = $cb->( POST "http://localhost/api/star/xxxxx" );
       is $res->code => 404, "not found xxxxx";
   };

   subtest star_405 => sub {
       my $res = $cb->( PUT "http://localhost/api/star/${name}" );
       is $res->code => 405, "method not allowed";
   };

   subtest star_head => sub {
       my $res = $cb->( HEAD "http://localhost/api/star/${name}" );
       is $res->code => 200, "head ok";
   };

   subtest star_get_before => sub {
       my $res = $cb->( GET "http://localhost/api/star/${name}" );
       is $res->code => 200, "method not allowed GET";
       is $res->content_type => "text/plain";
       is $res->content => "0";
   };

   for my $n ( 1 .. 10 ) {
       subtest star_post => sub {
           my $res = $cb->( POST "http://localhost/api/star/${name}" );
           is $res->code => 200, "post ok";
           is $res->content => "${n}", "added count ${n}";
       };
   }

   subtest star_get_after => sub {
       my $res = $cb->( GET "http://localhost/api/star/${name}" );
       is $res->code => 200, "get ok";
       is $res->content_type => "text/plain";
       is $res->content => "10";
   };

};

done_testing;
