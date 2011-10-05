package Dojo::Controller::Result;
use Ark 'Controller';

use Try::Tiny;
use Dojo::Models;

sub index :Path {
    my ($self, $c) = @_;
}


__PACKAGE__->meta->make_immutable;
