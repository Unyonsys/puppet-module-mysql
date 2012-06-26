class mysql::cluster (
  $debiansysmaint_password,
  $mysql_root_password,
  $wsrep_sst_auth,
  $wsrep_cluster_name,
  $wsrep_cluster_address,
  $wsrep_sst_method     = 'mysqldump',
  $wsrep_slave_threads  = $mysql::variables::slave_threads,
  $mysql_root_user      = 'root',
  $collection_tag       = undef,
) inherits mysql::variables {
  Class[ "${module_name}::server::authentication" ] -> Class[ "${module_name}::cluster::authentication" ] -> Class[ "${module_name}::cluster::config" ]
  Class[ "${module_name}::cluster::config" ] ~> Class[ "${module_name}::server::service" ]

  $collection_tag_real = $collection_tag ? {
    undef   => $wsrep_cluster_name,
    default => $collection_tag,
  }

  include "${module_name}::variables"
  class { "${module_name}::server":
    debiansysmaint_password => $mysql::cluster::debiansysmaint_password,
    mysql_root_password     => $mysql::cluster::mysql_root_password,
    mysql_root_user         => $mysql::cluster::mysql_root_user,
    collection_tag          => $collection_tag_real,
  }
  class { "${module_name}::cluster::authentication":
    wsrep_sst_auth => $mysql::cluster::wsrep_sst_auth,
  }
  class { "${module_name}::cluster::config":
    wsrep_cluster_name    => $mysql::cluster::wsrep_cluster_name,
    wsrep_cluster_address => $mysql::cluster::wsrep_cluster_address,
    wsrep_sst_method      => $mysql::cluster::wsrep_sst_method,
    wsrep_slave_threads   => $mysql::cluster::wsrep_slave_threads,
  }
}
