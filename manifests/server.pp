class mysql::server (
  $root_password,
  $root_user               = 'root',
  $debiansysmaint_password = undef,
  $collection_tag          = $::fqdn,
  $pkg                     = 'mysql-server',
  $pkg_ensure              = 'present',
  $template                = 'my.cnf.erb',
  $config_options          = {},
  $log_to_syslog           = false,
  $wsrep_urls              = '',
  $svc_hasstatus           = $mysql::variables::svc_hasstatus,
  $svc_pattern             = $mysql::variables::svc_pattern,
) inherits mysql::variables {

  anchor { "${module_name}::begin": } -> Class["${module_name}::server::user"]
  Class["${module_name}::server::service"] -> anchor { "${module_name}::end": }


  Class[ "${module_name}::server::user" ]    -> Class[ "${module_name}::server::install" ]
  Class[ "${module_name}::server::install" ] -> Class[ "${module_name}::server::config" ]
  Class[ "${module_name}::server::install" ] -> Class[ "${module_name}::server::authentication" ]
  Class[ "${module_name}::server::config" ] ~> Class[ "${module_name}::server::service" ]

  include "${module_name}::variables"
  if $debiansysmaint_password {
    Class[ "${module_name}::server::debiansysmaint" ] -> Class[ "${module_name}::server::install" ]
    class { "${module_name}::server::debiansysmaint":
      debiansysmaint_password => $mysql::server::debiansysmaint_password,
    }
  }
  class { "${module_name}::server::user": }
  class { "${module_name}::server::install":
    root_user       => $mysql::server::root_user,
    root_password   => $mysql::server::root_password,
    pkg             => $mysql::server::pkg,
    pkg_ensure      => $mysql::server::pkg_ensure,
  }
  class { "${module_name}::server::config":
    root_user      => $mysql::server::root_user,
    root_password  => $mysql::server::root_password,
    template       => $mysql::server::template,
    config_options => $mysql::server::config_options,
    log_to_syslog  => $mysql::server::log_to_syslog,
    wsrep_urls     => $mysql::server::wsrep_urls,
  }
  class { "${module_name}::server::service":
    svc_hasstatus => $mysql::server::svc_hasstatus,
    svc_pattern   => $mysql::server::svc_pattern,
  }

  class { "${module_name}::server::authentication":
    root_user     => $mysql::server::root_user,
    root_password => $mysql::server::root_password,
  }

  Database       <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
  Database_user  <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
  Database_grant <<| tag == $collection_tag |>> { require => Class[ "${module_name}::server::service" ] }
}
