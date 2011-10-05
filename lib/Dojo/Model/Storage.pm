package Dojo::Model::Storage;
use utf8;
use Any::Moose;
use Carp;
use Dojo::Models;

has backend => (
    is => 'rw',
);

no Any::Moose;

sub set_result {
    my ($self, $key, $correct) = @_;

    my $backend = $self->backend;
    my $answered = $backend->incr("answered_${key}", 1)
                   || $backend->set("answered_${key}", 1);

    my $corrected = $correct ? $backend->incr("corrected_${key}")
                               || $backend->set("corrected_${key}", 1)
                             : $backend->get("corrected_${key}");
    return {
        answered  => $answered  || 0,
        corrected => $corrected || 0,
    };
}

sub get_result {
    my ($self, $key) = @_;
    my $result = $self->backend->get_multi("answered_${key}", "corrected_${key}");
    return {
        answered  => $result->{"answered_${key}"}  || 0,
        corrected => $result->{"corrected_${key}"} || 0,
    };
}

sub add_star {
    my ($self, $key) = @_;
    $self->backend->incr("star_${key}", 1)
        or $self->backend->set("star_${key}", 1);
}

sub get_star {
    my ($self, $key) = @_;
    $self->backend->get("star_${key}") || 0;
}

1;
