package Dojo::Controller::Question;
use Ark 'Controller';

use Try::Tiny;
use Dojo::Models;

sub index :Path {
    my ($self, $c) = @_;
    # redirect random question # TODO: didn't show duplicate question
    $c->redirect_and_detach('/question/' . models('Questions')->random_next);
}

sub question :Path :Args {
    my ($self, $c, @args) = @_;

    my $q = try {
        models('Questions')->get(join '/', @args);
    } or $c->detach('/default');

    $c->stash->{'q'} = $q;

    if ('POST' eq $c->req->method) {
        my $choice = $c->req->param('choice');
        if ($choice and $choice =~ /^\d+$/ and defined $q->choices->[ $choice - 1 ]) {
            my $right = 0;
            if ($choice == $q->answer_number) {
                $right = 1;
            }

            $c->stash->{right} = $right;
            $c->view('MT')->template('question/answer');
        }
        else {
            $c->stash->{err} = 'Please choice an answer';
        }
    }
}

__PACKAGE__->meta->make_immutable;
