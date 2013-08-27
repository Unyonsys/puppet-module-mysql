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
  package { $packages:
    ensure  => $pkg_ensure,
  }
}
