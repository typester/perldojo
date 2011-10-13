package Dojo::Model::Storage;
use utf8;
use Any::Moose;
use Carp;
use Dojo::Models;
use Scalar::Util qw/ blessed /;

has backend => (
    is => 'rw',
);

no Any::Moose;

sub set_result {
    my ($self, $key, $correct) = @_;

    my $author;
    if ( ref $key &&  blessed($key) && $key->can("name") ) {
        $author = $key->author_name;
        $key    = $key->name;
    }

    my $backend = $self->backend;
    my $answered = $backend->incr("answered:${key}", 1)
                   || $backend->set("answered:${key}", 1)
                   || 1;

    my $corrected = $correct ? $backend->incr("corrected:${key}")
                               || $backend->set("corrected:${key}", 1)
                             : $backend->get("corrected:${key}");
    my $p = sprintf("%.1f", $corrected / $answered * 100);
    $backend->set( "percentage:${key}" => $p );

    if ($author) {
        my $aa = $backend->incr("author_answered:${author}", 1)
                 || $backend->set("author_answered:${author}", 1)
                 || 1;
        my $ac = $correct ? $backend->incr("author_corrected:${author}", 1)
                            || $backend->set("author_corrected:${author}", 1)
                            || 1
                          : $backend->get("author_corrected:${author}");
        $backend->set(
            "author_percentage:${author}" => sprintf("%.1f", $ac / $aa * 100),
        );
    }

    return {
        answered  => $answered  || 0,
        corrected => $corrected || 0,
    };
}

sub get_result {
    my ($self, $key) = @_;

    $key = $key->name
        if blessed $key && $key->can("name");

    my $result = $self->backend->get_multi("answered:${key}", "corrected:${key}");
    return {
        answered  => $result->{"answered:${key}"}  || 0,
        corrected => $result->{"corrected:${key}"} || 0,
    };
}

sub add_star {
    my ($self, $key) = @_;

    my $author;
    if ( blessed $key && $key->can("name") ) {
        $author = $key->author_name;
        $key    = $key->name;
    }

    if ($author) {
        $self->backend->incr("author_star:${author}", 1)
            or $self->backend->set("author_star:${author}", 1);
    }

    $self->backend->incr("star:${key}", 1)
        or $self->backend->set("star:${key}", 1);

}

sub get_star {
    my ($self, $key) = @_;

    $key = $key->name
        if blessed $key && $key->can("name");

    $self->backend->get("star:${key}") || 0;
}

sub get_authors_by_percentage {
    my $self = shift;

    my $code = $self->backend->can('get_authors_by_percentage');
    $code ? $code->($self->backend, @_)
          : [];
}

sub get_authors_by_star {
    my $self = shift;

    my $code = $self->backend->can('get_authors_by_star');
    $code ? $code->($self->backend, @_)
          : [];
}

sub get_icon {
    my $self = shift;
    my $q    = shift;
    $self->backend->get("gravatar_uri:" . $q->name);
}

sub get_author_icon {
    my $self = shift;
    my $name = shift;
    $self->backend->get("author_gravatar_uri:" . $name);
}

sub get_author_uri {
    my $self = shift;
    my $name = shift;
    $self->backend->get("author_github_uri:" . $name);
}

sub set_icon {
    my $self = shift;
    my $q    = shift;
    my $uri  = shift;

    $self->backend->set("gravatar_uri:" . $q->name => $uri);
    $self->backend->set("author_gravatar_uri:" . $q->author_name => $uri);
    $self->backend->set("author_github_uri:"   . $q->author_name => $q->author_uri);
}

sub set {
    my $self = shift;
    $self->backend->set(@_);
}

sub get {
    my $self = shift;
    $self->backend->get(@_);
}

1;
