use strict;
use warnings;
use Test::More;
use Dancer::Config 'setting';
use Dancer::Session::Redis;

can_ok 'Dancer::Session::Redis', qw(create retrieve flush destroy init redis);

# no settings
eval { Dancer::Session::Redis->create };
like $@, qr/redis_session is not defined/, 'settings for backend is not found';

# invalid settings
setting redis_session => [];
eval { Dancer::Session::Redis->create };
like $@, qr/redis_session must be a hash reference/, 'settings is not a hashref';

# incomplete settings
setting redis_session => {};
eval { Dancer::Session::Redis->create };
like $@, qr/redis_session should.*either server or sock parameter/, 'connection param is not found in settings';

done_testing();
