class mysql::server::debiansysmaint (
  $debiansysmaint_password,
) {
  file { "${mysql::variables::conf_folder}":
    ensure => directory,
  }
  file { "${mysql::variables::conf_folder}/debian.cnf":
    ensure  => file,
    content => template( "${module_name}/debian.cnf.erb" ),
  }
}
