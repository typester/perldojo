package Dojo::Model::AnswerSheet;
use utf8;
use Any::Moose;
use Carp;

use Clone qw/ clone /;
use Storable;
use MIME::Base64 3.11;
use Digest::SHA qw/ sha1_hex /;

has questions => (
    is      => "rw",
    isa     => "ArrayRef",
    default => sub { [] },
);

has results => (
    is      => "rw",
    isa     => "ArrayRef",
    default => sub { [] },
);

has current => (
    is      => "rw",
    isa     => "Int",
    default => 1,
);

no Any::Moose;

sub score {
    my $self = shift;
    int( $self->corrects / $self->total * 100 );
}

sub rank {
    my $self = shift;
    int( (99 - $self->score) / 25 ) + 1;
}

sub set_result {
    my $self = shift;
    my $correct = shift;
    $self->results->[ $self->current - 1 ] = $correct ? 1 : 0;
}

sub go_next {
    my $self = shift;
    $self->current( $self->current + 1 );
}

sub total {
    my $self = shift;
    return scalar @{ $self->questions };
}

sub current_question {
    my $self = shift;
    $self->questions->[ $self->current - 1 ];
}

sub next_question {
    my $self = shift;
    $self->questions->[ $self->current ];
}

sub set_current_question {
    my $self = shift;
    my $name = shift;
    my $n = 0;
    my $found;
    for my $q (@{ $self->questions }) {
        $n++;
        if ($q->name eq $name) {
            $self->current($n);
            $found = 1;
            last;
        }
    }
    return unless $found;
    $self->current_question;
}

sub serialize {
    my $self = shift;
    my $r = {
        questions => [ map { $_->name } @{ $self->questions } ],
        results   => clone( $self->results ),
        current   => $self->current,
    };
    MIME::Base64::encode_base64url( Storable::nfreeze($r) );
}

sub deserialize {
    my $class = shift;
    my %args  = @_;

    my $r = eval {
        Storable::thaw( MIME::Base64::decode_base64url( $args{serialized} ) );
    };
    if ($@) {
        die $@;
    }
    my $self = $class->new($r);

    for my $qname (@{ $r->{questions} }) {
        $qname = $args{questions}->get($qname);
    }

    $self;
}

sub digest {
    my $self = shift;
    sha1_hex( $self->serialize );
}

sub corrects {
    my $self = shift;
    scalar grep { $_ } @{ $self->results };
}

1;
