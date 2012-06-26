class mysql::client {
  include "${module_name}::variables"
  class { "${module_name}::client::install": }
}
