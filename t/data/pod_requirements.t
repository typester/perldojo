use Test::More;
use File::Find ();
use Pod::HTMLEmbed;
use FindBin;

my $parser = Pod::HTMLEmbed->new;

File::Find::find(sub {
    return unless $_ =~ /.+\.pod$/;

    my $pod = $parser->load($File::Find::name);

    ok $pod->section('QUESTION'), "$File::Find::name has QUESTION ok";
    ok $pod->section('CHOICES'), "$File::Find::name has CHOICES ok";
    ok $pod->section('ANSWER'), "$File::Find::name has ANSWER ok";
    ok $pod->section('AUTHOR'), "$File::Find::name has AUTHOR ok";
}, "$FindBin::Bin/../../data");

done_testing;
