class mysql::server::service {
  service { $mysql::variables::mysql_service:
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }
}
