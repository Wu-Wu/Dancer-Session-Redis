Dancer-Session-Redis
====================

Redis backend for Dancer Session Engine.

[![Build Status](https://travis-ci.org/Wu-Wu/Dancer-Session-Redis.png)](https://travis-ci.org/Wu-Wu/Dancer-Session-Redis)

- - - - - - - - - -

INSTALLATION
------------

To install this module type the following:

    perl Makefile.PL
    make
    make test
    make install

SYNOPSYS
--------

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


DESCRIPTION
-----------

This module is a Redis backend for the session engine of Dancer application. This module is a descendant
of [Dancer::Session](http://search.cpan.org/perldoc?Dancer::Session)


CONFIGURATION
-------------

In order to use this session engine, you have to set up a few settings (in the app or app's configuration file).

*   **session**

    Set the vaue to `Redis`. Required parameter.

*   **redis_session**

    Settings for backend.

    *   `server`

        Hostname and port of redis-server instance which will be used to store session data. This one is **required**.

    *   `password`

        Password string for redis-server's AUTH command to processing any other commands. Optional.
        Check the redis-server manual for directive **requirepass** if you would to use redis internal authentication.

    *   `database`

        Database # to store session data. Optional. Default value is 0.

    *   `expire`

        Session TTL. Optional. Default value is 900 (seconds).

    *   `ping`

        Time (in seconds) to check connection alive and re-establish in case of closed connection. Optional. Default value
        is 5 (seconds). Redis server close connection after a client is idle for seconds but server instance might be
        configured to not close client's connection. Check the redis server manual.

    *   `debug`

        Enables debug information to STDERR, including all interactions with the redis-server. Optional. Default value is 0.


SEE ALSO
--------

[Dancer](http://search.cpan.org/perldoc?Dancer)

[Dancer::Session](http://search.cpan.org/perldoc?Dancer::Session)

[Storable](http://search.cpan.org/perldoc?Storable)

[Redis](http://search.cpan.org/perldoc?Redis)

[http://redis.io](http://redis.io/)

COPYRIGHT AND LICENCE
---------------------

Copyright (C) 2012 by Anton Gerasimov

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

