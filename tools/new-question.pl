#!/usr/bin/env perl
use strict;
use warnings;
no warnings 'uninitialized';

use Text::MicroTemplate;
use Getopt::Long;
use utf8;
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

GetOptions(
    '--force|f' => \my $force,
    '--author'  => \my $author,
    '--github'  => \my $github,
) or die "Failed.\n";


chomp($author = `git config user.name`)    unless length $author;
chomp($github = `git config github.user`)  unless length $github;

$author = '[AUTHOR NAME HERE]' unless length $author;
$github = '[GITHUB URI HERE]'  unless length $author;

my $renderer = Text::MicroTemplate->new(
    template    => do { local $/; <DATA> },
    escape_func => sub { $_[0] },
)->build();

# main

my($file) = @ARGV;
if(defined $file) {
    $file = "data/$file" if $file !~ m{ \A data/ }xms;
    $file = "$file.pod"  if $file !~ m{  \.pod \z}xms;

    if(not -e $file or $force) {
        open my $fh, '>:utf8', $file
            or die "Cannot open $file for writing: $!\n";
        select $fh;
        print STDERR "create $file\n";
    }
    else {
        die "File $file exists. Please --force if you are sure.\n";
    }
}
else {
    die "Usage: $0 [--force] [--author=AUTHOR] [--github=GITHUB] NAME\n";
}

print $renderer->($author, "http://github.com/$github");

__DATA__
? my($author, $github) = @_;

=encoding utf-8

=head1 QUESTION

[ WRITE QUESTION HERE ]

=head1 CHOICES

=over

=item 1.

[ CHOISE 1 ]

=item 2.

[ CHOISE 2 ]

=item 3.

[ CHOISE 3 ]

=item 4.

[ CHOISE 4 ]

=item 5.

[ CHOISE 5 ]

=back

=head1 ANSWER

N

=head1 EXPLANATION

[ EXPLANATION HERE ]

=head1 AUTHOR

<?= $author ?>
<?= $github ?>

=cut
