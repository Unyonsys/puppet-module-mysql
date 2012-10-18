class mysql::variables {
  case $::operatingsystem {
    /(?i-mx:ubuntu|debian)/ : {
      $conf_folder   = '/etc/mysql'
      $data          = '/var/lib/mysql'
      $user          = 'mysql'
      $group         = 'mysql'
      $home          = '/var/lib/mysql'
      $service       = 'mysql'
      $slave_threads = $::processorcount * 2
    }
    default : {
      fail('Unsupported operating system')
    }
  }
}
