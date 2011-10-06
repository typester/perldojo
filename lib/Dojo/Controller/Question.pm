package Dojo::Controller::Question;
use Ark 'Controller';

use Try::Tiny;
use Dojo::Models;

sub auto :Private { 1 }

sub restore_answer_sheet :Private {
    my ($self, $c) = @_;

    my $as;
    if ( my $serialized = $c->req->cookies->{ $c->config->{cookie_name} } ) {
        $c->log->info("cookie found. restore answer_sheet");
        $as = try {
            models("AnswerSheet")->deserialize(
                serialized => $serialized,
                questions  => models("Questions"),
            );
        } catch {
            my $e = $_;
            $c->log->error("restore failed. $e");
        };
    }
    $c->stash->{answer_sheet} = $as;
}


sub index :Path {
    my ($self, $c) = @_;

    my $as = models("AnswerSheet")->new;
    $as->questions([ models("Questions")->get_shuffled(5) ]);
    $c->stash->{answer_sheet} = $as;
    $c->redirect_and_detach(
        $c->uri_for('/question/' . $as->current_question->name)->as_string,
    );
}

sub question :Path :Args {
    my ($self, $c, @args) = @_;

    my $as   = $c->forward("restore_answer_sheet");
    my $name = join "/", @args;

    my $q = $as ? $as->set_current_question($name)
                : eval { models('Questions')->get($name) };

    if (!$q || $@) {
        $c->log->error("cannot load question: $name $@");
        $c->stash->{reset} = 1;
        $c->detach('/default');
    }
    $c->stash->{'q'} = $q;

    if ( $c->req->method eq "POST" )  {
        $c->forward("question_POST");
    }
}

sub question_POST :Private {
    my ($self, $c) = @_;

    my $as = $c->stash->{answer_sheet};
    my $q  = $c->stash->{"q"};

    my $choice = $c->req->param('choice');
    if ( $choice and $choice =~ /^\d+$/ and defined $q->choices->[ $choice - 1 ] ) {
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

        if ($as) {
            $as->set_result($right ? 1 : 0);
        }
        $c->view('MT')->template('question/answer');
    }
    else {
        $c->stash->{err} = 'Please choice an answer';
    }
}

sub result :Local :Args(1) {
    my ($self, $c, $serialized) = @_;
    my $as = try {
        models("AnswerSheet")->deserialize(
            serialized => $serialized,
            questions  => models("Questions"),
        );
    };
    if (!$as || $@) {
        $c->log->error("Can't restore answer sheet. $@");
        $c->detach("/default");
    }
    $c->stash->{answer_sheet} = $as;
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
