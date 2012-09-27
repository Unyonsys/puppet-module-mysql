class mysql::cluster (
  $debiansysmaint_password,
  $mysql_root_password,
  $wsrep_sst_auth,
  $wsrep_cluster_name,
  $wsrep_cluster_address,
  $status_password,
  $status_user          = 'clusterstatus',
  $wsrep_sst_method     = 'rsync',
  $wsrep_slave_threads  = $mysql::variables::slave_threads,
  $mysql_root_user      = 'root',
  $mysql_config_options = {},
  $collection_tag       = undef,
) inherits mysql::variables {
  Class[ "mysql::server::authentication" ] -> Class[ "mysql::cluster::authentication" ] -> Class[ "mysql::cluster::config" ]
  Class[ "mysql::cluster::config" ] ~> Class[ "mysql::server::service" ]
  Class[ "mysql::cluster::status" ] ~> Class[ 'xinetd' ]
  Package[ 'percona-xtradb-cluster-server-5.5' ] -> Class[ "mysql::cluster" ]

  $collection_tag_real = $collection_tag ? {
    undef   => $wsrep_cluster_name,
    default => $collection_tag,
  }

  include mysql::variables
  class { mysql::server:
    debiansysmaint_password => $mysql::cluster::debiansysmaint_password,
    mysql_root_password     => $mysql::cluster::mysql_root_password,
    mysql_root_user         => $mysql::cluster::mysql_root_user,
    collection_tag          => $collection_tag_real,
    use_percona_pkg         => true,
    mysql_config_options    => $mysql::cluster::mysql_config_options,
  }
  class { mysql::cluster::authentication:
    wsrep_sst_auth => $mysql::cluster::wsrep_sst_auth,
  }
  class { mysql::cluster::config:
    wsrep_cluster_name    => $mysql::cluster::wsrep_cluster_name,
    wsrep_cluster_address => $mysql::cluster::wsrep_cluster_address,
    wsrep_sst_auth        => $mysql::cluster::wsrep_sst_auth,
    wsrep_sst_method      => $mysql::cluster::wsrep_sst_method,
    wsrep_slave_threads   => $mysql::cluster::wsrep_slave_threads,
  }
  class { mysql::cluster::status:
    status_user     => $mysql::cluster::status_user,
    status_password => $mysql::cluster::status_password,
  }
}
