package Dojo::Model::Gravatar;

use strict;
use warnings;
use Furl;
use JSON;

our $UA;
our $Cache;

sub ua {
    $UA ||= Furl->new;
}

sub gravatar_uri {
    my $class  = shift;
    my $author = shift;

    if ($author =~ m{https?://(?:secure\.)?gravatar\.com/avatar/([0-9a-f]+)}) {
        return "http://www.gravatar.com/avatar/$1";
    }
    elsif ($author =~ m{https?://github\.com/(\w+)}) {
        my $github_id = $1;
        my $api = "http://github.com/api/v2/json/user/show/${github_id}";
        my $res = $class->ua->get($api);
        if ($res->is_success) {
            my $data = decode_json($res->content);
            my $id   = $data->{user}->{gravatar_id};
            return "http://www.gravatar.com/avatar/${id}";
        }
    }
    else {
        return "http://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm";
    }
}

1;
