use lib 'lib';
use Dojo;
use Plack::Builder;

my $app = Dojo->new;
$app->setup;

# preload models
use Dojo::Models;
Dojo::Models->instance->load_all;

builder {
    enable 'Plack::Middleware::StackTrace'; # be disable after published!
    $app->handler;
};

