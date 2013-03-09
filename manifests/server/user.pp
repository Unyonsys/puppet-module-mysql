class mysql::server::user {
  user { $mysql::variables::user:
    uid  => '411',
    gid  => $mysql::variables::group,
    home => $mysql::variables::home,
  }
  group { $mysql::variables::group:
    gid => '411',
  }
}
