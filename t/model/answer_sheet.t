use strict;
use warnings;
use utf8;
use FindBin;

use Test::More;
use t::Utils;

use_ok 'Dojo::Model::AnswerSheet';
use_ok 'Dojo::Model::Questions';
my $qs = Dojo::Model::Questions->new(
    data_dir => "$FindBin::Bin/questions",
);

my $serialized;

subtest "create" => sub {
    my $as = Dojo::Model::AnswerSheet->new(
        questions => [ map { $qs->get($_) } qw/ foo bar baz / ],
    );

    isa_ok $as => "Dojo::Model::AnswerSheet";
    is $as->total   => 3, "total questions";
    is $as->current => 1, "default position";
    is $as->current_question->name => "foo", "current_questions 1";
    ok $as->go_next;
    is $as->current => 2, "next position";
    is $as->current_question->name => "bar", "current_questions 2";

    $serialized = $as->serialize;
    like $serialized => qr{\A[a-zA-Z0-9_\-]+\z};
};

note "serialized: $serialized";

subtest restore => sub {
    my $as = Dojo::Model::AnswerSheet->deserialize(
        serialized => $serialized,
        questions  => $qs,
    );
    isa_ok $as => "Dojo::Model::AnswerSheet";
    is $as->total   => 3, "total questions";
    is $as->current => 2, "restored current";
    is $as->current_question->name => "bar", "current_questions 2";
    $as->go_next;
    is $as->current => 3, "next current 3";
    is $as->current_question->name => "baz", "current_questions 3";
};

done_testing;
