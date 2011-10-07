package Dojo::Model::Storage::DBI;

use strict;
use warnings;
use Any::Moose;

has dbh => (
    is => "rw",
);

sub incr {
    my $self = shift;
    my $id  = shift;
    my $sth  = $self->dbh->prepare("UPDATE data SET value = value + 1 WHERE id=?");
    my $r = $sth->execute($id);
    return if $r == 0;
    $self->get($id);
}

sub get {
    my $self = shift;
    my $id  = shift;
    my $sth  = $self->dbh->prepare("SELECT value FROM data WHERE id=?");
    $sth->execute($id);
    my $r = $sth->fetchrow_arrayref;
    return $r->[0] if $r;
    return;
}

sub set {
    my $self = shift;
    my ($id, $value) = @_;
    my $dbh = $self->dbh;

    $dbh->begin_work;
    my $sth = $dbh->prepare("UPDATE data SET value = ? WHERE id=?");
    my $r = $sth->execute($value, $id);
    if ($r == 0) {
        $sth = $dbh->prepare("INSERT INTO data (id, value) VALUES (?, ?)");
        $sth->execute($id, $value);
    }
    $value = $self->get($id);
    $dbh->commit;

    $value;
}

sub get_multi {
    my $self = shift;
    my @ids = @_;

    my $sth = $self->dbh->prepare(
        "SELECT id, value FROM data WHERE id IN(" . join(",", map {"?"} @ids) . ")"
    );
    $sth->execute(@ids);
    my $result = {};
    while (my $r = $sth->fetchrow_arrayref) {
        $result->{ $r->[0] } = $r->[1];
    }
    $result;
}

sub get_authors_by_star {
    my $self  = shift;
    my $limit = shift;

    $self->_get_authors_by(
        order => "value + 0 DESC, id",
        key   => "author_star:%",
        limit => $limit,
    );
}

sub get_authors_by_percentage {
    my $self  = shift;
    my $limit = shift;

    $self->_get_authors_by(
        order => "value + 0, id",
        key   => "author_percentage:%",
        limit => $limit,
    );
}

sub _get_authors_by {
    my $self = shift;
    my %args = @_;

    my $sth = $self->dbh->prepare(
        "SELECT id, value FROM data WHERE id LIKE ? ORDER BY $args{order} LIMIT ?"
    );
    $sth->execute($args{key}, $args{limit});
    my @result;
    while ( my $r = $sth->fetchrow_arrayref ) {
        my (undef, $name) = split ":", $r->[0], 2;
        push @result, {
            name  => $name,
            value => $r->[1],
        };
    }
    return wantarray ? @result : \@result;
}

sub schema {
    my $class = shift;
    my $sql =<<END;
CREATE TABLE data (
    `id`   varchar(255) not null primary key,
    `value` text not null,
    `last_updated` timestamp not null
) ENGINE=INNODB;
END
}

1;
