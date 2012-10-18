class mysql::server (
  $root_password,
  $root_user               = 'root',
  $debiansysmaint_password = undef,
  $collection_tag          = $::fqdn,
  $use_percona_pkg         = false,
  $config_options          = {},
  $log_to_syslog           = false,
  $wsrep_urls              = '',
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
    root_user       => $mysql::server::root_user,
    root_password   => $mysql::server::root_password,
    use_percona_pkg => $mysql::server::use_percona_pkg,
  }
  class { "${module_name}::server::config":
    root_user       => $mysql::server::root_user,
    root_password   => $mysql::server::root_password,
    use_percona_pkg => $mysql::server::use_percona_pkg,
    config_options  => $mysql::server::config_options,
    log_to_syslog   => $mysql::server::log_to_syslog,
    wsrep_urls      => $mysql::server::wsrep_urls,
  }
  class { "${module_name}::server::service": }

  class { "${module_name}::server::authentication":
    root_user     => $mysql::server::root_user,
    root_password => $mysql::server::root_password,
  }

  Database       <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
  Database_user  <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
  Database_grant <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
}
