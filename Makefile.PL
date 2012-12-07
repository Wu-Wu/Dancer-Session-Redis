use 5.010;
use ExtUtils::MakeMaker;

my %options = (
    'NAME'          => 'Dancer::Session::Redis',
    'VERSION_FROM'  => 'lib/Dancer/Session/Redis.pm',
    'AUTHOR'        => 'Anton Gerasimov <me@zyxmasta.com>',
    'ABSTRACT_FROM' => 'lib/Dancer/Session/Redis.pm',
    'LICENSE'       => 'perl',
    'PREREQ_PM'     => {
        'Dancer'   => '1.3072',
        'Redis'    => 0,
        'strict'   => 0,
        'warnings' => 0,
        'parent'   => 0,
        'Storable' => 0,
        'Carp'     => 0,
    },
    'BUILD_REQUIRES' => {
        'Test::More' => '0.98',
    },
    'MIN_PERL_VERSION' => '5.10.0',
    'test' => {
        'TESTS' => 't/*.t',
    }
);

WriteMakefile(%options);
