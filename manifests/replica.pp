class mysql::replica (
  $debiansysmaint_password,
  $root_password,
  $replicate_password,
  $replicate_peer,
  $server_id,
  $auto_increment_offset,
  $auto_increment_increment,
  $replicate_user  = 'replicate',
  $replicate_port  = '3306',
  $root_user       = 'root',
  $config_options  = {},
  $pkg             = 'mysql-server', 
  $pkg_ensure      = 'present',
  $log_to_syslog   = false,
  $collection_tag  = undef,
) inherits mysql::variables {
  Class[ "${module_name}::server::authentication" ] -> Class[ "${module_name}::replica::authentication" ]
  Class[ "${module_name}::replica::config" ] ~> Class[ "${module_name}::server::service" ]

  $collection_tag_real = $collection_tag ? {
    undef   => $wsrep_cluster_name,
    default => $collection_tag,
  }

  include mysql::variables
  class { mysql::server:
    debiansysmaint_password => $mysql::replica::debiansysmaint_password,
    root_user               => $mysql::replica::root_user,
    root_password           => $mysql::replica::root_password,
    pkg                     => $mysql::replica::pkg,
    pkg_ensure              => $mysql::replica::pkg_ensure,
    collection_tag          => $mysql::replica::collection_tag_real,
    config_options          => $mysql::replica::config_options,
    log_to_syslog           => $mysql::replica::log_to_syslog,
    wsrep_urls              => $mysql::replica::wsrep_urls,
    svc_hasstatus           => false,
    svc_pattern             => 'mysqld',
  }
  class { mysql::replica::authentication:
    user     => $replicate_user,
    password => $replicate_password,
  }
  class { mysql::replica::config:
    replicate_user           => $mysql::replica::replicate_user,
    replicate_password       => $mysql::replica::replicate_password,
    replicate_peer           => $mysql::replica::replicate_peer,
    replicate_port           => $mysql::replica::replicate_port,
    server_id                => $mysql::replica::server_id,
    auto_increment_offset    => $mysql::replica::auto_increment_offset,
    auto_increment_increment => $mysql::replica::auto_increment_increment,
  }
}
