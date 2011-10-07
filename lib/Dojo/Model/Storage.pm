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
                   || $backend->set("answered:${key}", 1);

    my $corrected = $correct ? $backend->incr("corrected:${key}")
                               || $backend->set("corrected:${key}", 1)
                             : $backend->get("corrected:${key}");
    my $p = sprintf("%.1f", $corrected / $answered * 100);
    $backend->set( "percentage:${key}" => $p );

    if ($author) {
        my $aa = $backend->incr("author_answered:${author}", 1)
                 || $backend->set("author_answered:${author}", 1);
        my $ac = $correct ? $backend->incr("author_corrected:${author}", 1)
                            || $backend->set("author_corrected:${author}", 1)
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
        $self->backend->incr("author_star:${key}", 1)
            or $self->backend->set("author_star:${key}", 1);
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

1;
