package Dojo::Controller::API;
use Ark 'Controller';
use 5.12.0;
use Try::Tiny;
use Dojo::Models;

sub ping :Local {
    my ($self, $c) = @_;
    $c->res->content_type("text/plain; charset=utf-8");
    $c->res->body("ok");
}

sub star :Local :Args {
    my ($self, $c, @args) = @_;

    my $name = join "/", @args;
    my $q = try {
        models('Questions')->get($name);
    } or $c->detach('/default');

    my $star = "";
    given ( $c->req->method ) {
        when ("POST") {
            $star = models("Storage")->add_star( $q->name );
        }
        when ("GET") {
            $star = models("Storage")->get_star( $q->name );
        }
        when ("HEAD") {
        }
        default {
            $c->log->error("method: %s not allowed", $c->req->method);
            $c->res->status(405);
        }
    }

    $c->res->content_type("text/plain; charset=utf-8");
    $c->res->body($star);
}

__PACKAGE__->meta->make_immutable;
