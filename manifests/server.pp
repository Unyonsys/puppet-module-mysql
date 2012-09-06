class mysql::server (
  $mysql_root_password,
  $mysql_root_user         = 'root',
  $debiansysmaint_password = undef,
  $collection_tag          = $::fqdn,
  $use_percona_pkg         = false,
) inherits mysql::variables {

  Class[ "${module_name}::server::install" ] -> Class[ "${module_name}::server::config" ] ~> Class[ "${module_name}::server::service" ]
  Class[ "${module_name}::server::install" ] -> Class[ "${module_name}::server::authentication" ]
  Class[ "${module_name}::client::install" ] -> Class[ "${module_name}::server::install" ]

  include "${module_name}::variables"
  if $debiansysmaint_password {
    Class[ "${module_name}::server::debiansysmaint" ] -> Class[ "${module_name}::server::install" ]
    class { "${module_name}::server::debiansysmaint":
      debiansysmaint_password => $mysql::server::debiansysmaint_password,
    }
  }
  class { "${module_name}::server::install":
    mysql_root_user     => $mysql::server::mysql_root_user,
    mysql_root_password => $mysql::server::mysql_root_password,
    use_percona_pkg     => $mysql::server::use_percona_pkg,
  }
  class { "${module_name}::server::config":
    mysql_root_user     => $mysql::server::mysql_root_user,
    mysql_root_password => $mysql::server::mysql_root_password,
    use_percona_pkg     => $mysql::server::use_percona_pkg,
  }
  class { "${module_name}::server::service": }

  class { "${module_name}::server::authentication":
    mysql_root_user     => $mysql::server::mysql_root_user,
    mysql_root_password => $mysql::server::mysql_root_password,
  }

  Database       <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
  Database_user  <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
  Database_grant <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
}
