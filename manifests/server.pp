class mysql::server (
  $mysql_root_password,
  $mysql_root_user = 'root',
) inherits mysql::variables {

  Class[ "${module_name}::server::install" ] -> Class[ "${module_name}::server::config" ] ~> Class[ "${module_name}::server::service" ]
  Class[ "${module_name}::server::install" ] -> Class[ "${module_name}::server::authentication" ]
  Class[ "${module_name}::client::install" ] -> Class[ "${module_name}::server::install" ]

  include "${module_name}::variables"
  class { "${module_name}::server::install":
    mysql_root_user     => $mysql::server::mysql_root_user,
    mysql_root_password => $mysql::server::mysql_root_password,
  }
  class { "${module_name}::server::config":
    mysql_root_user     => $mysql::server::mysql_root_user,
    mysql_root_password => $mysql::server::mysql_root_password,
  }
  class { "${module_name}::server::service": }

  class { "${module_name}::server::authentication":
    mysql_root_password => $mysql::server::mysql_root_password,
  }
}
