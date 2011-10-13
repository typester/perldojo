package Dojo::Controller::Question;
use Ark 'Controller';

use Try::Tiny;
use Dojo::Models;

sub auto :Private { 1 }

sub restore_answer_sheet :Private {
    my ($self, $c) = @_;

    my $as;
    if ( my $serialized = $c->req->cookies->{ $c->config->{cookie_name} } ) {
        $c->log->debug("cookie found. restore answer_sheet from $serialized")
            if $c->debug;
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

    $c->forward("keep_session");
    $c->redirect_and_detach(
        $c->uri_for('/question/' . $as->current_question->name)->as_string,
    );
}

sub question :Path :Args {
    my ($self, $c, @args) = @_;

    my $as   = $c->forward("restore_answer_sheet");
    my $name = join "/", @args;

    my $q;
    if ($as) {
        $q = $as->set_current_question($name);
    }
    unless ($q) {
        eval {
            $q = models('Questions')->get($name);
            undef  $as;
            delete $c->stash->{answer_sheet};
            $c->log->info("remove session.");
        };
    }
    if (!$q || $@) {
        $c->log->error("cannot load question: $name $@");
        $c->stash->{reset} = 1;
        $c->detach('/default');
    }
    $c->stash->{'q'} = $q;

    if ( $c->req->method eq "POST" )  {
        $c->forward("question_POST");
    }
    $c->forward("keep_session");
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
        my $r = models("Storage")->set_result( $q => $right );
        $c->stash->{percentage} = sprintf("%.1f", $r->{corrected} / $r->{answered} * 100)
            if $r && $r->{answered};
        $c->stash->{star}
            = models("Storage")->get_star($q);

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
    $c->forward("reset_session");
}

sub icon :Local :Args {
    my ($self, $c, @args) = @_;

    my $name = join "/", @args;
    my $q = eval { models('Questions')->get($name) };
    if (!$q || $@) {
        $c->log->error("cannot load question: $name $@");
        $c->detach('/default');
    }

    my $uri = models("Storage")->get_icon($q);
    unless ($uri) {
        $uri = $q->gravatar_uri;
        $c->log->info("set gravatar uri: %s", $uri);
        models("Storage")->set_icon($q => $uri);
    }
    $c->res->header( "Cache-Control" => "max-age=86400" );
    $c->redirect($uri);
}

sub keep_session :Private {
    my ($self, $c) = @_;

    my $as = $c->stash->{answer_sheet}
        or return;
    $c->res->cookies->{ $c->config->{cookie_name} } = {
        value => $as->serialize,
    };
}

sub reset_session :Private {
    my ($self, $c) = @_;

    $c->res->cookies->{ $c->config->{cookie_name} } = {
        value   => "",
        expires => "-1y",
    };
}


__PACKAGE__->meta->make_immutable;
