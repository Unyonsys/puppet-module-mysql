class mysql::server::install (
  $root_password,
  $root_user,
  $use_percona_pkg,
  $pkg_ensure,
) {

  if $use_percona_pkg {
    $packages = [ 'percona-xtradb-cluster-server-5.5', $::mysql::variables::percona_toolkit ]
    file { '/usr/bin/wsrep_sst_common':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/mysql/wsrep_sst_common',
      before => Package[ $packages ],
    }
  }
  else {
    $packages = [ 'mysql-server', $::mysql::variables::percona_toolkit ]
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
    ensure  => $pkg_ensure,
    require => User[ $mysql::variables::user ],
  }
  exec { 'init_mysql_rootpw':
    command => "mysqladmin -u root password ${root_password}",
    unless  => 'test -f /root/.my.cnf',
    require => Package[ $packages ],
  }
}
