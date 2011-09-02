use inc::Module::Install;
name 'Dojo';
all_from 'lib/Dojo.pm';
readme_from 'lib/Dojo.pm';

perl_version '5.008';

requires 'parent';
requires 'Try::Tiny';

requires 'Ark' => '0.2';



test_requires 'Test::More' => '0.88';
tests 't/*.t';
author_tests 'xt';

auto_set_repository;

WriteAll;
