class mysql::client (
  $use_percona_pkg = false,
) {
  include "${module_name}::variables"
  class { "${module_name}::client::install":
    use_percona_pkg => $mysql::client::use_percona_pkg,
  }
}
