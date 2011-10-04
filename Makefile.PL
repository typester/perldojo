use inc::Module::Install;
name 'Dojo';
all_from 'lib/Dojo.pm';
readme_from 'lib/Dojo.pm';

perl_version '5.008';

requires 'parent';
requires 'Try::Tiny';

requires 'Ark' => '0.2';

requires 'Pod::HTMLEmbed' => '0.04';

test_requires 'Test::More' => '0.88';
test_requires 'Test::TCP';

tests 't/*.t t/*/*.t';

WriteAll;
