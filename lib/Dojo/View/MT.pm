package Dojo::View::MT;
use Ark 'View::MT';

use Text::MicroTemplate ();

has '+macro' => default => sub {
    return {
        encoded_string => sub { Text::MicroTemplate::encoded_string(@_) },
    };
};

__PACKAGE__->meta->make_immutable;

