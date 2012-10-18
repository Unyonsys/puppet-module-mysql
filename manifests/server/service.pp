class mysql::server::service {
  service { $mysql::variables::service:
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }
}
