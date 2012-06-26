class mysql::server::config (
  $mysql_root_user,
  $mysql_root_password,
) {

  file { "${mysql::variables::mysql_root}/my.cnf":
    ensure  => file,
    content => template( "${module_name}/my.cnf.erb" ),
  }
}
