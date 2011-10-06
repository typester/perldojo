# -*- mode:perl -*-
use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use t::Utils;
use Path::Class qw/ file dir /;

my $app = setup_app;

test_psgi $app, sub {
   my $cb = shift;

   subtest index => sub {
       my $res = $cb->( GET "http://localhost/" );
       is $res->code, 200;
       like $res->content => qr{\A<\!DOCTYPE html>};
   };

   subtest notfound => sub {
       my $res = $cb->( POST "http://localhost/xxxxx" );
       is $res->code => 404, "not found xxxxx";
   };

   my $sid;
   my $next_uri;
   subtest start => sub {
       my $res = $cb->( GET "http://localhost/question" );

       is $res->code => 302, "status ok";
       $next_uri = $res->header("Location");
       like $next_uri => qr{^http://.*/question/.+$};

       $sid = res2sid($res);
       ok $sid;
   };

   subtest question => sub {
       note "GET $next_uri";
       my $res = $cb->( GET $next_uri,
                        Cookie => "dojostate=$sid" );
       $sid = res2sid($res);
   };
};

done_testing;

sub res2sid {
    my $res    = shift;
    if ( $res->header("Set-Cookie") =~ m{dojostate=(.+?);} ) {
        note $1;
        return $1;
    }
    return;
}
