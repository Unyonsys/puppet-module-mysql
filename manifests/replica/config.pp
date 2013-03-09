class mysql::replica::config (
  $replicate_user,
  $replicate_password,
  $replicate_peer,
  $replicate_port,
  $server_id,
  $auto_increment_offset,
  $auto_increment_increment,
) {
  file { "${mysql::variables::conf_folder}/conf.d/replica_settings.cnf":
    ensure  => file,
    content => template( "${module_name}/replication_settings.cnf.erb" ),
  }
  exec { 'init_replication':
    command => "mysql -e \"CHANGE MASTER TO
                  MASTER_HOST='${replicate_peer}',
                  MASTER_USER='${replicate_user}',
                  MASTER_PASSWORD='${replicate_password}',
                  MASTER_PORT=${replicate_port};\"",
    creates => "${mysql::variables::data}/master.info",
  }
}
