class mysql::cluster::config (
  $wsrep_cluster_name,
  $wsrep_sst_auth,
  $wsrep_sst_method,
  $wsrep_slave_threads,
) {
  file { "${mysql::variables::conf_folder}/conf.d/galera_replication.cnf":
    ensure  => file,
    content => template( "${module_name}/galera_replication.cnf.erb" ),
  }
}
