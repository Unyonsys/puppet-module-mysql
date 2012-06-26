class mysql::server::authentication (
  $mysql_root_password,
) {
  exec { 'set_mysql_rootpw':
    command => "mysqladmin -u root password ${mysql_root_password}",
    unless  => "mysqladmin -u root -p${mysql_root_password} status > /dev/null",
  }
  database_user { [ 'root@127.0.0.1', "root@${hostname}", 'root@::1' ]:
    ensure  => absent,
    require => File[ '/root/.my.cnf' ],
  }
  file { '/root/.my.cnf':
    ensure  => file,
    content => template( "${module_name}/root_my.cnf.erb" ),
    require => Exec[ 'set_mysql_rootpw' ],
  }
}
