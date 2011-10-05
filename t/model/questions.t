use strict;
use warnings;
use utf8;
use FindBin;

use Test::More;

use_ok 'Dojo::Model::Questions';

my $q = Dojo::Model::Questions->new(
    data_dir => "$FindBin::Bin/questions",
);
isa_ok $q, 'Dojo::Model::Questions';

is scalar keys %{$q->data}, 4, '4 data loaded ok';

ok my $foo = $q->get('foo'), 'foo loaded ok';
ok my $foobar = $q->get('foo/bar'), 'foo/bar loaded ok';

like $foo->question, qr!<p>test question</p>!, 'question ok';

is_deeply $foo->choices, [qw/foo bar buzz hoge fuga/], 'coices ok';

is $foo->answer, 'hoge', 'answer ok';

like $foo->explanation, qr!<p>test explanation</p>!, 'explanation ok';

done_testing;
