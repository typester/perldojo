package Dojo::Controller;
use Ark 'Controller';
use Dojo::Models;

sub auto :Private {
    my ($self, $c) = @_;
    $c->stash->{storage} = models("Storage");
}

sub default :Path :Args {
    my ($self, $c) = @_;
    $c->res->status(404);
    $c->res->body('404 Not Found');
}

sub index :Path {
    my ($self, $c) = @_;

    $c->stash->{by_p} = models("Storage")->get_authors_by_percentage(5);
    $c->stash->{by_s} = models("Storage")->get_authors_by_star(5);
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

sub icon :Local :Args {
    my ($self, $c, @args) = @_;

    my $name = join "/", @args;
    my $uri  = models("Storage")->get_author_icon($name)
            || Dojo::Model::Gravatar->default;
    $c->res->header( "Cache-Control" => "max-age=86400" );
    $c->redirect($uri);
}


__PACKAGE__->meta->make_immutable;
