class mysql::cluster::status (
  $status_user,
  $status_password,
) {
  file { '/usr/local/bin/clustercheck':
    ensure  => file,
    content => template( "${module_name}/clustercheck.erb" ),
    mode    =>  '0755',
  }
  augeas { 'mysqlchk':
    context => '/files/etc/services',
    changes => [
      "set /files/etc/services/service-name[port = '9200']/port 9200",
      "set /files/etc/services/service-name[port = '9200'] mysqlchk",
      "set /files/etc/services/service-name[port = '9200']/protocol tcp",
    ],
  }
  database_user { "${status_user}@localhost":
    ensure        => present,
    password_hash => mysql_password( $status_password ),
  }
  database_grant { "${status_user}@localhost":
    privileges => [ 'process_priv' ],
  }
}
