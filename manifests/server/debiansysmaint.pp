class mysql::server::debiansysmaint (
  debiansysmaint_password,
) {
  file { "${mysql::variables::mysql_root}":
    ensure => directory,
  }
  file { "${mysql::variables::mysql_root}/debian.cnf":
    ensure  => file,
    content => template( "${module_name}/debian.cnf.erb" ),
  }
}
