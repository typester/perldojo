use lib 'lib';
use Dojo;

my $app = Dojo->new;
$app->setup;

# preload models
use Dojo::Models;
Dojo::Models->instance->load_all;

$app->handler;

