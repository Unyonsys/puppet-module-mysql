class mysql::cluster::authentication (
  $wsrep_sst_auth,
) {
  $sst_auth = split( $wsrep_sst_auth, ':')
  $sst_username = $sst_auth[0]
  $sst_password = $sst_auth[1]
  database_user { "${sst_username}@%":
    ensure        => present,
    password_hash => mysql_password( $sst_password ),
  }
  database_grant { "${sst_username}@%":
    privileges => [ 'all' ],
  }
}
