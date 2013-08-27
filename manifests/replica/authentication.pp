class mysql::replica::authentication (
  $user,
  $password,
) {
  database_user { "${user}@%":
    ensure        => present,
    password_hash => mysql_password( $password ),
  }
  database_grant { "${user}@%":
    privileges => [ 'repl_slave_priv', 'repl_client_priv' ],
  }
}
