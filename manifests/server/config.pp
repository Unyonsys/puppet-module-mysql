class mysql::server::config (
  $root_user,
  $root_password,
  $use_percona_pkg,
  $config_options,
  $log_to_syslog,
  $wsrep_urls,
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
  file { "${mysql::variables::conf_folder}/my.cnf":
    ensure  => file,
    content => template( $my_cnf ),
  }

  file { "${mysql::variables::conf_folder}/conf.d/options.cnf":
    ensure  => file,
    content => template( "${module_name}/options.cnf.erb" ),
  }

  if $log_to_syslog {
    file { "${mysql::variables::conf_folder}/conf.d/log_to_syslog.cnf":
      ensure  => file,
      content => "[mysqld_safe]\nsyslog",
    }
  }
}
