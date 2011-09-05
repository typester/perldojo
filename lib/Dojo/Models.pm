package Dojo::Models;
use strict;
use warnings;
use Ark::Models '-base';

register Questions => sub {
    my ($self) = @_;

    $self->ensure_class_loaded('Dojo::Model::Questions');
    Dojo::Model::Questions->new;
};

1;

