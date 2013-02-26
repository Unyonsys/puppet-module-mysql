class mysql::variables {
  case $::operatingsystem {
    /(?i-mx:ubuntu|debian)/ : {
      $conf_folder   = '/etc/mysql'
      $data          = '/var/lib/mysql'
      $user          = 'mysql'
      $group         = 'mysql'
      $home          = '/var/lib/mysql'
      $service       = 'mysql'
      $svc_hasstatus = true
      $svc_pattern   = undef
      $slave_threads = $::processorcount * 2
      if versioncmp( $::operatingsystemrelease, '11.10') > 0 {
        $percona_toolkit = 'percona-toolkit'
      }
      else {
        $percona_toolkit = 'maatkit'
      }
    }
    default : {
      fail('Unsupported operating system')
    }
  }
}
