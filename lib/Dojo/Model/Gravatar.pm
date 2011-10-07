package Dojo::Model::Gravatar;

use strict;
use warnings;
use Furl;
use JSON;
use Digest::MD5 qw/ md5_hex /;

our $UA;
our $Cache;

sub ua {
    $UA ||= Furl->new;
}

sub default {
    "http://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm";
}


sub gravatar_uri {
    my $class  = shift;
    my $author = shift;

    if ($author =~ qr{($Email::Valid::Loose::Addr_spec_re)}) {
        return "http://www.gravatar.com/avatar/" . md5_hex($1);
    }
    elsif ($author =~ m{https?://(?:secure\.)?gravatar\.com/avatar/([0-9a-f]+)}) {
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
        return default();
    }
}

1;
