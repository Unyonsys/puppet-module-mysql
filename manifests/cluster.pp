class mysql::cluster (
  $debiansysmaint_password,
  $root_password,
  $wsrep_sst_auth,
  $wsrep_cluster_name,
  $wsrep_urls,
  $status_password,
  $status_user          = 'clusterstatus',
  $wsrep_sst_method     = 'rsync',
  $wsrep_slave_threads  = $mysql::variables::slave_threads,
  $root_user            = 'root',
  $config_options       = {},
  $pkg_ensure           = 'present',
  $log_to_syslog        = false,
  $collection_tag       = undef,
) inherits mysql::variables {
  Class[ "mysql::server::authentication" ] -> Class[ "mysql::cluster::authentication" ]
  Class[ "mysql::cluster::config" ] ~> Class[ "mysql::server::service" ]
  Class[ "mysql::server::service" ] -> Class[ "mysql::server::authentication" ]
  Class[ "mysql::cluster::status" ] ~> Class[ 'xinetd' ]
  Package[ 'percona-xtradb-cluster-server-5.5' ] -> Class[ "mysql::cluster" ]

  $collection_tag_real = $collection_tag ? {
    undef   => $wsrep_cluster_name,
    default => $collection_tag,
  }

  include mysql::variables
  class { mysql::server:
    debiansysmaint_password => $mysql::cluster::debiansysmaint_password,
    root_password           => $mysql::cluster::root_password,
    root_user               => $mysql::cluster::root_user,
    collection_tag          => $collection_tag_real,
    use_percona_pkg         => true,
    pkg_ensure              => $mysql::cluster::pkg_ensure,
    config_options          => $mysql::cluster::config_options,
    log_to_syslog           => $mysql::cluster::log_to_syslog,
    wsrep_urls              => $mysql::cluster::wsrep_urls,
    svc_hasstatus           => false,
    svc_pattern             => 'mysqld',
  }
  class { mysql::cluster::authentication:
    wsrep_sst_auth => $mysql::cluster::wsrep_sst_auth,
  }
  class { mysql::cluster::config:
    wsrep_cluster_name  => $mysql::cluster::wsrep_cluster_name,
    wsrep_sst_auth      => $mysql::cluster::wsrep_sst_auth,
    wsrep_sst_method    => $mysql::cluster::wsrep_sst_method,
    wsrep_slave_threads => $mysql::cluster::wsrep_slave_threads,
  }
  class { mysql::cluster::status:
    status_user     => $mysql::cluster::status_user,
    status_password => $mysql::cluster::status_password,
  }
}
