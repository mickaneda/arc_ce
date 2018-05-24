class arc_ce::users (
  $test_user = "griduser1",
  $gid = 13370,
  ){
  group {
      'grid':
        ensure => present,
        name   => 'grid',
        gid => $gid,
    }

  user{'griduser1':
    ensure     => present,
      comment    => 'grid user for tests',
      password   => '!!',
      shell      => '/bin/bash',
      gid        => $gid,
      home       => "/home/$test_user",
      managehome => true,
  }
  Group['grid'] -> User[$test_user]
}
