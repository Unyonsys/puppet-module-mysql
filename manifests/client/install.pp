class mysql::client::install (
  $use_percona_pkg,
) {
  if $use_percona_pkg {
    package { [ 'percona-xtradb-cluster-client-5.5', 'maatkit' ]:
      ensure => present,
    }
  }
  else {
    package { [ 'mysql-client', 'maatkit' ]:
      ensure => present,
    }
  }
}
