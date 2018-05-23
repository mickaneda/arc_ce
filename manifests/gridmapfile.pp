class arc_ce::gridmapfile (
  $test_user = "griduser1",
  $cert = "",
  ){
  if ($cert != ""){
    file { '/etc/grid-security/grid-mapfile':
      content => "\"$cert\" $test_user"
    }
  }
}
