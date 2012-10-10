MySQL module for Puppet
=======================

This module configures MySQL client and server on Debian like OS.
It has been developed under Ubuntu 12.04.

Description
-----------

The module is able to configure MySQL server either as standalone server
or in Galera cluster mode using Percona's packages.

When using Percona packages it is your responsibility to ensure the
repository is configured on your machines.
You can (should) also add this as a metaparameter to your class call
if you want something clean.

It is based on the official puppetlabs-mysql module especially for
the provider, types, functions, with a correction for IPV6 hostnames.

Usage
-----

### Client
    class { 'mysql::client':
        use_percona_pkg => true,
    }

### Client with Percona packages
    class { 'mysql::client':
        use_percona_pkg => true,
    }

### Server
    class { 'mysql::server':
        mysql_root_password     => hiera( 'mysql_root_password' ),
    }

You can also force the debiansysmaint_password as below, which will
preseed dpkg appropriately.

    class { 'mysql::server':
        debiansysmaint_password => hiera( 'debiansysmaint_password' ),
        mysql_root_password     => hiera( 'mysql_root_password' ),
    }

### Cluster

An example of cluster, with all the mandatory options.

    class { 'mysql::cluster':
        debiansysmaint_password => hiera( 'debiansysmaint_password' ),
        mysql_root_password     => hiera( 'mysql_root_password' ),
        wsrep_sst_auth          => hiera( 'wsrep_sst_auth' ),
        wsrep_cluster_name      => hiera( 'wsrep_cluster_name' ),
        wsrep_urls              => hiera( 'wsrep_urls' ),
        status_password         => hiera( 'mysql_status_password' ),
    }

You can pass some other options as shown below.
$mysql_config_options expects a hash so you can pass a lot of options
without having to modify the module.

We use wsrep_urls syntax instead of wsrep_cluster_adress because it is
more flexible.

    class { 'mysql::cluster':
        debiansysmaint_password => hiera( 'debiansysmaint_password' ),
        mysql_root_password     => hiera( 'mysql_root_password' ),
        wsrep_sst_auth          => hiera( 'wsrep_sst_auth' ),
        wsrep_cluster_name      => hiera( 'wsrep_cluster_name' ),
        wsrep_urls              => hiera( 'wsrep_urls' ),
        wsrep_slave_threads     => hiera( 'wsrep_slave_threads' ),
        status_password         => hiera( 'mysql_status_password' ),
        mysql_config_options    => hiera( 'mysql_config_options' ),
        log_to_syslog           => hiera( 'log_to_syslog' ),
    }


Dependencies
------------

Contact
-------

Bruno Leon <bruno.leon@unyonsys.com>

License
-------

This software is distributed under the GNU General Public License
version 2 or any later version. See the LICENSE file for details.

Copyright
---------

Copyright (C) 2012 UNYONSYS SARL
