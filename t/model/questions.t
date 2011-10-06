# -*- mode:perl -*-
use strict;
use warnings;
use utf8;
use FindBin;

use Test::More;

use_ok 'Dojo::Model::Questions';

my $qs = Dojo::Model::Questions->new(
    data_dir => "$FindBin::Bin/questions",
);
isa_ok $qs, 'Dojo::Model::Questions';

is scalar keys %{$qs->data}, 4, '4 data loaded ok';

ok my $foo = $qs->get('foo'), 'foo loaded ok';
ok my $foobar = $qs->get('foo/bar'), 'foo/bar loaded ok';

like $foo->question, qr!<p>test question</p>!, 'question ok';

is_deeply $foo->choices, [qw/foo bar buzz hoge fuga/], 'coices ok';

is $foo->answer, 'hoge', 'answer ok';

like $foo->explanation, qr!<p>test explanation</p>!, 'explanation ok';

my @q = $qs->get_shuffled(3);
is scalar @q => 3, "shuffled 3";
isa_ok $_ => "Dojo::Model::Question" for @q;

for (1 .. 10) {
    my $key = $qs->random_next;
    my $q   = $qs->get($key);
    isa_ok $q, "Dojo::Model::Question";
    is $q->name => $key;
}

done_testing;
