use inc::Module::Install;
name 'Dojo';
all_from 'lib/Dojo.pm';
#readme_from 'lib/Dojo.pm';

perl_version '5.008';

requires 'parent';
requires 'Try::Tiny';

requires 'Ark' => '0.2';

requires 'Pod::HTMLEmbed' => '0.04';
requires 'MIME::Base64'   => '3.11';
requires 'Cache::Memcached::Fast';
requires 'List::Util';
requires 'Furl';
requires 'Digest::MD5';
requires 'Email::Valid::Loose';

test_requires 'Test::More' => '0.88';
test_requires 'Test::TCP';
test_requires 'pQuery';

tests 't/*.t t/*/*.t';

WriteAll;
