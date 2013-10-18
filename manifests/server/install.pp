class mysql::server::install (
  $root_password,
  $root_user,
  $pkg,
  $pkg_ensure,
) {

  $packages = [ $pkg, $::mysql::variables::percona_toolkit ]
  package { $packages:
    ensure  => $pkg_ensure,
  }
}
