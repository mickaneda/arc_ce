class arc_ce::gridmapfile (
  $test_user = "griduser1",
  $cert = "",
  ){
  if ($cert != ""){
    file { '/etc/grid-security/grid-mapfile':
      content => "'/C=JP/O=KEK/OU=CRC/CN=KANEDA Michiru' $test_user"
    }
  }
}
