package Dojo::Model::Questions;
use utf8;
use Any::Moose;
use Carp;

use File::Find ();
use Pod::HTMLEmbed;

use Dojo::Models;
use Dojo::Model::Question;
use List::Util qw/ shuffle /;

has data_dir => (
    is      => 'ro',
    default => sub {
        models('home')->subdir('data')->stringify;
    },
);

has data => (
    is      => 'ro',
    default => sub { {} },
);

has _parser => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        Pod::HTMLEmbed->new;
    },
);

no Any::Moose;

sub BUILD {
    my ($self) = @_;
    $self->_load;
}

sub _load {
    my ($self) = @_;

    File::Find::find(sub {
        return unless $_ =~ /.+\.pod$/;

        if (my ($key, $obj) = $self->_parse_file($File::Find::name)) {
            $self->data->{ $key } = $obj;
        }
        else {
            warn 'Invalid pod: ', $File::Find::name, "\n";
        }

    }, $self->data_dir);

    1;
}

sub _parse_file {
    my ($self, $file) = @_;

    my $pod = $self->_parser->load($file);

    # check required sections
    if ($pod->section('QUESTION') &&
        $pod->section('CHOICES') &&
        $pod->section('ANSWER') &&
        $pod->section('AUTHOR') ) {

        (my $key = $file) =~ s!(^\Q@{[ $self->data_dir ]}\E/|\.pod$)!!g;
        return ($key, $pod);
    }

    return ();
}

sub get {
    my ($self, $key) = @_;

    my $data = $self->data->{ $key }
        or croak "Question: $key is not found";

    Dojo::Model::Question->new(
        name => $key,
        data => $self->data->{ $key },
    );
}

sub random_next {
    my ($self) = @_;

    my @keys = keys %{ $self->data };
    $keys[ int rand scalar @keys ];
}

sub get_shuffled {
    my ($self, $num) = @_;

    my @data;
    my $n = 0;
    for my $key ( shuffle keys %{ $self->data } ) {
        push @data, Dojo::Model::Question->new(
            name => $key,
            data => $self->data->{ $key },
        );
        last if ++$n == $num;
    }
    @data;
}

__PACKAGE__->meta->make_immutable;
