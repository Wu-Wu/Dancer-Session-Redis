use strict;
use warnings;
use Test::More;
use Dancer::Config 'setting';
use Dancer::Session::Redis;

my $default_server = '127.0.0.1:6379';

# no settings
eval { Dancer::Session::Redis->create };
like $@, qr/Settings 'redis_session' is not defined/,
    "Settings 'redis_session' is mandatory";

# invalid settings
setting redis_session => [];
eval { Dancer::Session::Redis->create };
like $@, qr/Settings 'redis_session' must be a hash reference/,
    "Settings 'redis_session' is not hashref";

# incomplete settings
setting redis_session => {};
eval { Dancer::Session::Redis->create };
like $@, qr/Parameter 'redis_session.server' or 'redis_session.sock' have to be defined/,
    "Parameter 'redis_session.server' or 'redis_session.sock' is not defined";

# complete settings
setting redis_session => {
    server => $default_server,
};

SKIP: {
    eval { Redis->new(server => $default_server, debug => 0) };
    skip "redis-server needs to be running on '$default_server' for this test", 7 if $@;

    my $session;
    eval { $session = Dancer::Session::Redis->create };
    is $@, '', 'Session engine created ok';
    isa_ok $session, 'Dancer::Session::Redis';
    can_ok $session, qw(create retrieve flush destroy init);

    my $sid = $session->id;
    ok $sid, "Session has an ID ($sid)";

    my $s1 = Dancer::Session::Redis->retrieve('XXX');
    is $s1, undef, 'Unknown session is not found';

    my $s2 = Dancer::Session::Redis->retrieve($sid);
    isa_ok $s2, 'Dancer::Session::Redis';
    is $s2->id, $sid, 'Valid session is found';
}

done_testing();
