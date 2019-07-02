class arc_ce::runtime_env (
  $setup_RTEs          = true,
  $runtimedir          = "/etc/arc/runtime",
  $rte_files           = {
    'ENV/PROXY'=>"puppet:///modules/${module_name}/RTEs/PROXY",
    'ENV/GLITE'=>"puppet:///modules/${module_name}/RTEs/GLITE",
    'APPS/HEP/ATLAS-SITE-LCG'=>"puppet:///modules/${module_name}/RTEs/ATLAS-SITE-LCG",
  },
  ){
  if $setup_RTEs {
    $rte_files.each |String $dest, String $orig| {
      $fullpath  = "${runtimedir}/${dest}"
      $directory = dirname($fullpath)
      exec {"mkdir for ${fullpath}":
        command => "/bin/mkdir -p ${directory}",
      }
      file { $fullpath:
        ensure  => present,
        source  => $orig,
      }
    }
  }
}
