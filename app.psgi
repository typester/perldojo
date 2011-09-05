use lib 'lib';

use Dojo;
use Dojo::Models;

use Plack::App::Directory;

my $root   = models('home')->subdir('root');
my $static = Plack::App::Directory->new({
    root => $root->stringify
})->to_app;

my $app = sub {
    my ($env) = @_;

    my $f = $root->file($env->{PATH_INFO});
    if (-f $f && -r _) {
        return $static->(@_);
    }
    else {
        # lazy build
        my $app = Dojo->new;
        $app->setup_minimal;

        $app->handler->(@_);
    }
};
