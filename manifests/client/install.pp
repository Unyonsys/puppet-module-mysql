class mysql::client::install {
  package { [ 'percona-xtradb-cluster-client-5.5', 'maatkit' ]:
    ensure => present,
  }
}
