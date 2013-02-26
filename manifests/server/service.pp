class mysql::server::service (
  $svc_hasstatus,
  $svc_pattern,
) {
  service { $mysql::variables::service:
    ensure     => running,
    enable     => true,
    hasstatus  => $svc_hasstatus,
    pattern    => $svc_pattern,
    hasrestart => true,
  }
}
