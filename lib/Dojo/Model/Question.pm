package Dojo::Model::Question;
use utf8;
use Any::Moose;
use Dojo::Model::Gravatar;
use Email::Valid::Loose;

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

has author_name => (
    is      => "rw",
    lazy    => 1,
    default => \&build_author_name,
);

has author_uri => (
    is      => "rw",
    lazy    => 1,
    default => \&build_author_uri,
);

no Any::Moose;

sub build_author_name {
    my $self   = shift;
    my $author = $self->author;
    my $addr_spec_re = $Email::Valid::Loose::Addr_spec_re;
    my $uri_re       = qr{s?https?://[-_.!~*'()a-zA-Z0-9;/?:\@&=+\$,%#]+};
    my $re           = qr{($addr_spec_re|$uri_re)};

    my $name = (split /$re/, $author)[0];
    $name =~ s{\A\s+}{}mg;
    $name =~ s{\s+\z}{}mg;
    $name;
}

sub build_author_uri {
    my $self   = shift;
    my $author = $self->author;
    if ($author =~ m{(https?://github\.com/\w+)}) {
        return $1;
    }
    return;
}

__PACKAGE__->meta->make_immutable;
