package Dojo::Controller;
use Ark 'Controller';

sub default :Path :Args {
    my ($self, $c) = @_;
    $c->res->status(404);
    $c->res->body('404 Not Found');
}

sub index :Path {
    my ($self, $c) = @_;
}

sub end :Private {
    my ($self, $c) = @_;

    $c->res->content_type('text/html; charset=utf-8') unless $c->res->content_type;
    $c->res->header("Cache-Control" => "private")
        unless defined $c->res->header("Cache-Control");

    unless ($c->res->has_body or $c->res->status =~ /^3/) {
        $c->forward( $c->view('MT') );
    }
}

__PACKAGE__->meta->make_immutable;
