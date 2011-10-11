package Dojo::Controller::Update;
use JSON;
use strict;
use Ark 'Controller';

sub index :Path :Args(1) {
    my ($self, $c, $key) = @_;

    if ($key ne $c->config->{update_key}) {
        $c->res->status(400);
        $c->log->error("invalid update_key: $key");
        $c->res->body("error");
        return;
    }

    if ($c->req->method ne "POST") {
        $c->res->status(405);
        $c->res->body("error");
    }

    my $ok = system(qw| git fetch github |) == 0
          && system(qw| git merge github/master |) == 0;

    if ($ok) {
        $c->res->body("ok");
    }
    else {
        $c->log->error("error $!");
        $c->res->status(500);
        $c->res->body("error");
    }
}

1;
