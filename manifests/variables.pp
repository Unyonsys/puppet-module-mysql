class mysql::variables {
  case $::operatingsystem {
    /(?i-mx:ubuntu|debian)/ : {
      $mysql_root    = '/etc/mysql'
      $mysql_data    = '/var/lib/mysql'
      $mysql_user    = 'mysql'
      $mysql_group   = 'mysql'
      $mysql_home    = '/var/lib/mysql'
      $mysql_service = 'mysql'
      $slave_threads = $::processorcount * 2
    }
    default : {
      fail('Unsupported operating system')
    }
  }
}
