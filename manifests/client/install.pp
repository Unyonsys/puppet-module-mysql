class mysql::client::install (
  $pkg,
) {
  package { [ $pkg ]:
    ensure => present,
  }
}
