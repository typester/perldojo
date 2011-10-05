package Dojo::Model::AnswerSheet;
use utf8;
use Any::Moose;
use Carp;

use Clone qw/ clone /;
use Storable;
use MIME::Base64 3.11;

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
    my $self = $class->new($r);

    for my $qname (@{ $r->{questions} }) {
        $qname = $args{questions}->get($qname);
    }

    $self;
}

1;
