package Dojo::Model::Question;
use utf8;
use Any::Moose;
use Dojo::Model::Gravatar;

has name => (
    is       => 'ro',
    required => 1,
);

has data => (
    is       => 'ro',
    required => 1,
    # isa => 'Pod::HTMLEmbed::Entry',
);

has question => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        $self->data->section('QUESTION');
    },
);

has explanation => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        $self->data->section('EXPLANATION');
    },
);

has author => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        my $author = $self->data->section('AUTHOR');
        $author =~ s{</?p>}{}g;
        $author;
    },
);

has choices => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my ($self) = @_;

        my $html = $self->data->section('CHOICES');
        my @choices = $html =~ m!<li>(.*?)</li>!gs;

        \@choices;
    },
);

has answer_number => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my ($self) = @_;

        my $html = $self->data->section('ANSWER');
        my ($number) = $html =~ m!<p>(\d+)</p>!;

        $number;
    },
);

has answer => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        $self->choices->[ $self->answer_number - 1 ];
    },
);

has gravatar_uri => (
    is      => "rw",
    lazy    => 1,
    default => sub {
        my $self = shift;
        Dojo::Model::Gravatar->gravatar_uri( $self->author );
    },
);

has author_html => (
    is      => "rw",
    lazy    => 1,
    default => \&build_author_html,
);

no Any::Moose;

sub build_author_html {
    my $self   = shift;
    my $author = $self->author;
    my $html   = "";

    $author =~ s{(https?://[^\s]+)}{
        my $uri = $1;
        (my $suri = $uri) =~ s{^https?://}{};
        return "" if $uri =~ /gravatar\.com/;
        sprintf q{<a href="%s">%s</a>}, $uri, substr($suri, 0, 30);
    }eg;
    $author;
}

__PACKAGE__->meta->make_immutable;
