class mysql::server::install (
  $root_password,
  $root_user,
  $use_percona_pkg,
) {

  if $use_percona_pkg {
    $packages = [ 'percona-xtradb-cluster-server-5.5', 'percona-xtrabackup' ]
  }
  else {
    $packages = [ 'mysql-server' ]
  }
  user { $mysql::variables::user:
    uid  => '411',
    gid  => $mysql::variables::group,
    home => $mysql::variables::home,
  }
  group { $mysql::variables::group:
    gid => '411',
  }
  package { $packages:
    ensure  => present,
    require => User[ $mysql::variables::user ],
  }
  exec { 'init_mysql_rootpw':
    command => "mysqladmin -u root password ${root_password}",
    unless  => 'test -f /root/.my.cnf',
    require => Package[ $packages ],
  }
}
