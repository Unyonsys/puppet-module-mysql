class mysql::server::authentication (
  $root_user,
  $root_password,
) {
  exec { 'set_mysql_rootpw':
    command => "mysqladmin -u root password ${root_password}",
    unless  => "mysqladmin -u root -p${root_password} status > /dev/null",
  }
  database_user { [ 'root@127.0.0.1', "root@${hostname}", 'root@::1' ]:
    ensure  => absent,
    require => File[ '/root/.my.cnf' ],
  }
  file { [ '/root/.my.cnf', '/etc/my.cnf' ] :
    ensure  => file,
    mode    => '0600',
    content => template( "${module_name}/root_my.cnf.erb" ),
    require => Exec[ 'set_mysql_rootpw' ],
  }
}
