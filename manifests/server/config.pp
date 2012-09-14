class mysql::server::config (
  $mysql_root_user,
  $mysql_root_password,
  $use_percona_pkg,
  $mysql_config_options,
) {
  if ! $use_percona_pkg {
    $my_cnf = "${module_name}/my.cnf.erb"
  }
  else {
    $my_cnf = "${module_name}/my.cnf_percona.erb"
  }

  if versioncmp($::operatingsystemrelease, '11.10') > 0 {
    $lc_messages_dir = true
  }
  else {
    $lc_messages_dir = false
  }
  file { "${mysql::variables::mysql_root}/my.cnf":
    ensure  => file,
    content => template( $my_cnf ),
  }

  file { "${mysql::variables::mysql_root}/conf.d/options.cnf":
    ensure  => file,
    content => template( "${module_name}/options.cnf.erb" ),
  }
}
