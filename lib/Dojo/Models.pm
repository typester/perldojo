package Dojo::Models;
use strict;
use warnings;
use Ark::Models '-base';

register Questions => sub {
    my ($self) = @_;

    $self->ensure_class_loaded('Dojo::Model::Questions');
    Dojo::Model::Questions->new;
};

register Storage => sub {
    my ($self) = @_;
    $self->ensure_class_loaded("Dojo::Model::Storage");
    $self->ensure_class_loaded("Cache::Memcached::Fast");

    Dojo::Model::Storage->new(
        backend => Cache::Memcached::Fast->new(
            $self->get('conf')->{storage}->{backend}->{args}
         || { servers => [ "127.0.0.1:11211" ] },
        ),
    );
};

1;

