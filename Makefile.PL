use 5.010;
use ExtUtils::MakeMaker;

my $meta_merge = {
    META_MERGE => {
        resources => {
            repository => 'https://github.com/Wu-Wu/Dancer-Session-Redis',
            bugtracker => 'https://github.com/Wu-Wu/Dancer-Session-Redis/issues',
        },
    }
};

my %options = (
    'NAME'          => 'Dancer::Session::Redis',
    'VERSION_FROM'  => 'lib/Dancer/Session/Redis.pm',
    'AUTHOR'        => 'Anton Gerasimov <chim@cpan.org>',
    'ABSTRACT_FROM' => 'lib/Dancer/Session/Redis.pm',
    'LICENSE'       => 'perl',
    'PREREQ_PM'     => {
        'Dancer'   => '1.3072',
        'Redis'    => '1.955',
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
    },
    $ExtUtils::MakeMaker::VERSION >= 6.50 ? (%$meta_merge) : (),
);

WriteMakefile(%options);
