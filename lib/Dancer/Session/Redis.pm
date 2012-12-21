package Dancer::Session::Redis;

# ABSTRACT: Redis backend for Dancer Session Engine
use strict;
use warnings;
use parent 'Dancer::Session::Abstract';
use Redis;
use Dancer::Config 'setting';
use Storable ();
use Carp ();

our $VERSION = '0.1.9';

my $_redis;
my %options = ();

sub init {
    my $self = shift;

    $self->SUPER::init(@_);

    # backend settings
    if (my $opts = setting('redis_session') ) {
        if (ref $opts and ref $opts eq 'HASH' ) {
            %options = (
                'server'   => $opts->{'server'}   || undef,
                'database' => $opts->{'database'} || 0,
                'expire'   => $opts->{'expire'}   || 900,
                'debug'    => $opts->{'debug'}    || 0,
                'ping'     => $opts->{'ping'}     || 5,
                'password' => $opts->{'password'} || undef,
            );
        } else {
            Carp::croak "Settings 'redis_session' must be a hash reference!";
        }
    } else {
        Carp::croak "Settings 'redis_session' is not defined!";
    }

    Carp::croak "Parameter 'redis_session.server' must be defined" unless defined $options{'server'};

    _redis_watchdog();
}

#
# check redis handle and re-establish connection
sub _redis_watchdog {
    if ($_redis->{handle}) {
        if (time - $_redis->{lastcheck} > $options{'ping'}) {
            if ($_redis->{handle}->ping) {
                $_redis->{lastcheck} = time;
                return $_redis->{handle};
            } else {
                Carp::carp "Lost redis connection. Reconnecting...";
                return _redis_get_handle();
            }
        }
    } else {
        return _redis_get_handle();
    }
}

#
# connect to redis server and return handle (or croaks)
sub _redis_get_handle {

    my %params = (
        server => $options{'server'},
        debug  => $options{'debug'},
    );

    $params{password} = $options{'password'} if $options{'password'};

    $_redis->{handle} = Redis->new(%params);

    $_redis->{lastcheck} = time if $_redis->{handle} && $_redis->{handle}->ping;

    $_redis->{handle} and return $_redis->{handle};

    Carp::croak "Unable connect to redis..." unless $_redis->{handle};
}

#
# create a new session
sub create {
    my ($class) = @_;

    $class->new->flush;
}

#
# fetch the session object by id
sub retrieve($$) {
    my ($class, $id) = @_;

    _redis_watchdog();
    $_redis->{handle}->select($options{'database'});
    $_redis->{handle}->expire($id => $options{'expire'});

    Storable::thaw($_redis->{handle}->get($id));
}

#
# delete session
sub destroy {
    my ($self) = @_;

    _redis_watchdog();
    $_redis->{handle}->select($options{'database'});
    $_redis->{handle}->del($self->id);
}

#
# flush session
sub flush {
    my ($self) = @_;

    _redis_watchdog();
    $_redis->{handle}->select($options{'database'});
    $_redis->{handle}->set($self->id => Storable::freeze($self));
    $_redis->{handle}->expire($self->id => $options{'expire'});

    $self;
}

1;
__END__

=head1 NAME

Dancer::Session::Redis - Redis backend for Dancer Session Engine

=head1 SYNOPSIS

    # in the Dancer config.yml:
    session: 'Redis'
    redis_session:
        server: 'redi.example.com:6379'
        password: 'QmG_kZECJAvAcDaWqqSqoNLUka5v3unMe_8sqYMh6ST'
        database: 1
        expire: 3600
        debug: 0
        ping: 5

    # or in the Dancer application:
    setting session       => 'Redis';
    setting redis_session => {
        server   => 'redi.example.com:6379',
        password => 'QmG_kZECJAvAcDaWqqSqoNLUka5v3unMe_8sqYMh6ST',
        database => 1,
        expire   => 3600,
        debug    => 0,
        ping     => 5,
    };

=head1 DESCRIPTION

This module is a Redis backend for the session engine of Dancer application. This module is a descendant
of L<Dancer::Session::Abstract>.

=head1 CONFIGURATION

In order to use this session engine, you have to set up a few settings (in the app or app's configuration file).

=over

=item * session

Set the vaue B<Redis>. Required parameter.

=item * redis_session

Settings for backend.

=over

=item I<server>

Hostname and port of redis-server instance which will be used to store session data. This one is B<required>.

=item I<password>

Password string for redis-server's AUTH command to processing any other commands. Optional. Check the redis-server
manual for directive I<requirepass> if you would to use redis internal authentication.

=item I<database>

Database # to store session data. Optional. Default value is 0.

=item I<expire>

Session TTL. Optional. Default value is 900 (seconds).

=item I<ping>

Time (in seconds) to check connection alive and re-establish in case of closed connection. Optional. Default value
is 5 (seconds). Redis server close connection after a client is idle for seconds but server instance might be
configured to not close client's connection. Check the redis server manual.

=item I<debug>

Enables debug information to STDERR, including all interactions with the redis-server. Optional. Default value is 0.

=back

=back

=head1 METHODS

=head2 init()

Validate settings and creates the initial connection to redis-server.

=head2 create()

Creates a new object, runs C<flush> and returns the object.

=head2 flush()

Writes the session information to the Redis database.

=head2 retrieve()

Retrieves session information from the Redis database.

=head2 destroy()

Deletes session information from the Redis database.

=head1 SEE ALSO

L<Dancer>

L<Dancer::Session>

L<Storable>

L<Redis>

L<redis.io|http://redis.io>


=head1 AUTHOR

Anton Gerasimov, E<lt>chim@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Anton Gerasimov

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
