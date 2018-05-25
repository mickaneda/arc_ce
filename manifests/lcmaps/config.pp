class arc_ce::lcmaps::config (
  $argus_server,
  $argus_port,
  $argus_resourceid,
  $argus_actionid,
  ) {
  file { '/etc/lcmaps/lcmaps.db':
    ensure  => present,
    content => template("${module_name}/lcmaps.db.erb"),
    require => Package[lcmaps],
  }
}
