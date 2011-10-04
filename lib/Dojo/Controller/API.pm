package Dojo::Controller::API;
use Ark 'Controller';

use Try::Tiny;
use Dojo::Models;

sub star :Local :Args {
    my ($self, $c, @args) = @_;

    my $q = try {
        models('Questions')->get(join '/', @args);
    } or $c->detach('/default');

    $c->stash->{'q'} = $q;

    if ('POST' eq $c->req->method) {
        my $star = models("Storage")->add_star( $q->name );
        $c->res->content_type("text/plain; charset=utf-8");
        $c->res->body($star);
    }
    else {
        $c->res->status(405);
        $c->res->body("error");
    }
}

__PACKAGE__->meta->make_immutable;
