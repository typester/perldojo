package Dojo::Controller::Question;
use Ark 'Controller';

use Try::Tiny;
use Dojo::Models;

sub auto :Private {
    my ($self, $c) = @_;

    if ( my $serialized = $c->req->cookies->{ $c->config->{cookie_name} } ) {
        $c->log->info("cookie found. restore answer_sheet");
        $c->stash->{answer_sheet} = try {
            models("AnswerSheet")->deserialize(
                serialized => $serialized,
                questions  => models("Questions"),
            );
        } catch {
            my $e = $_;
            $c->log->error("restore failed. $e");
        };
    }

    1;
}


sub index :Path {
    my ($self, $c) = @_;

    my $as = models("AnswerSheet");
    $as->questions([ models("Questions")->get_shuffled(5) ]);
    $c->stash->{answer_sheet} = $as;

    $c->redirect_and_detach('/question/' . $as->current_question->name);
}

sub question :Path :Args {
    my ($self, $c, @args) = @_;

    my $name = join "/", @args;
    my $q = try {
        models('Questions')->get($name);
    };
    unless ($q) {
        $c->log->error("cannot load question: $name");
        $c->detach('/default');
    }

    $c->stash->{'q'} = $q;

    if ('POST' eq $c->req->method) {
        my $choice = $c->req->param('choice');
        if ($choice and $choice =~ /^\d+$/ and defined $q->choices->[ $choice - 1 ]) {
            my $right = 0;
            if ($choice == $q->answer_number) {
                $right = 1;
            }

            $c->stash->{right} = $right;
            my $r = models("Storage")->set_result( $q->name, $right );
            $c->stash->{percentage} = sprintf("%.1f", $r->{corrected} / $r->{answered} * 100)
                if $r && $r->{answered};
            $c->stash->{star}
                = models("Storage")->get_star( $q->name );

            if (my $as = $c->stash->{answer_sheet}) {
                $as->set_result($right ? 1 : 0);
                $as->go_next;
            }
            $c->view('MT')->template('question/answer');
        }
        else {
            $c->stash->{err} = 'Please choice an answer';
        }
    }
}

sub result :Local :Args(1) {
    my ($self, $c, $serialized) = @_;

    $c->stash->{answer_sheet} = try {
        models("AnswerSheet")->deserialize(
            serialized => $serialized,
            questions  => models("Questions"),
        );
    } or $c->detach("/default");

    $c->stash->{reset} = 1;
}

sub end :Private {
    my ($self, $c) = @_;

    my $as = $c->stash->{reset}
           ? undef
           : $c->stash->{answer_sheet};
    if ($as) {
        $c->res->cookies->{ $c->config->{cookie_name} } = {
            value => $as->serialize,
        };
    }
    else {
        $c->res->cookies->{ $c->config->{cookie_name} } = {
            value   => "",
            expires => "-1d",
        };
    }
    $c->forward("/end");
}


__PACKAGE__->meta->make_immutable;
