class mysql::client (
  $pkg = 'mysql-client',
) {
  include "${module_name}::variables"
  class { "${module_name}::client::install":
    pkg => $mysql::client::pkg,
  }
}
