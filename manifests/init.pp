# Class: arc_ce
#
# This module manages arc_ce
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class arc_ce (
  $install_from_repository      = 'nordugrid',
  $manage_repository = true, #if set to no, no repository will be setup
  $accounting_archives = '/var/run/arc/urs',
  $allow_new_jobs      = 'yes',
  $enable_apel         = true,
  $apel_testing        = true,
  $jobreport_logfile_dir = '',
  $apel_urbatch        = '1000',
  $apply_fixes         = false,
  $arex_port           = '60000',
  $cmd_prefix          = '',
  $argus_server        = 'argus.example.com',
  $argus_port          = '8154',
  $argus_resourceid    = 'http://authz-interop.org/xacml/resource/resource-type/arc',
  $argus_actionid      = 'http://glite.org/xacml/action/execute',
  $authorized_vos      = [],
  $benchmark_results   = [
    'SPECINT2000 222',
    'SPECFP2000 333',
    'HEPSPEC2006 444'],
  $benchmark_type = 'HEPSPEC',
  $cache_dir           = ['/var/cache/arc'],
  $cluster_alias       = 'MINIMAL Computing Element',
  $cluster_comment     = 'This is a minimal out-of-box CE setup',
  $cluster_cpudistribution      = ['16cpu:12'],
  $cluster_description = {
    'OSFamily'      => 'linux',
    'OSName'        => 'ScientificSL',
    'OSVersion'     => '6.4',
    'OSVersionName' => 'Carbon',
    'CPUVendor'     => 'AMD',
    'CPUClockSpeed' => '3100',
    'CPUModel'      => 'AMD Opteron(tm) Processor 4386',
    'NodeMemory'    => '1024',
    'totalcpus'     => '42',
  }
  ,
  $lrmsconfig          = '',
  $cluster_is_homogenious       = true,
  $cluster_nodes_private        = true,
  $cluster_owner       = 'Bristol HEP',
  $cores_per_worker    = '16',
  $cpu_scaling_reference_si00 = '3100',
  $debug               = false,
  $domain_name         = 'GOCDB-SITENAME',
  $emi_repo_version    = '3',
  $enable_firewall     = true,
  $enable_glue1        = false,
  $enable_glue2        = true,
  $enable_trustanchors = true,
  $glue_site_web       = 'http://www.bristol.ac.uk/physics/research/particle/',
  $globus_port_range   = [50000, 52000],
  $gridftp_max_connections      = '100',
  $hepspec_per_core    = '11.17',
  $infosys_registration = {
    'clustertouk1' => {
      targethostname => 'index1.gridpp.rl.ac.uk',
      targetport => '2135',
      targetsuffix => 'Mds-Vo-Name=UK,o=grid',
      regperiod => '120',},

    'clustertouk2' => {
       targethostname => 'index2.gridpp.rl.ac.uk',
       targetport => '2135',
       targetsuffix => 'Mds-Vo-Name=UK,o=grid',
       regperiod => '120',}
   },

  $log_directory       = '/var/log/arc',
  $shared_filesystem   = 'no',
  $allowsubmit         = [],
  $lrms                = 'fork',
  $pbs_bin_path        = '',
  $pbs_log_path        = '',
  $mail                = 'gridmaster@hep.lu.se',
  $nordugrid_repo_version = '15.03',
  $queues              = {},
  $resource_location   = 'Bristol, UK',
  $resource_latitude   = '51.4585',
  $resource_longitude  = '-02.6021',
  $run_directory       = '/var/run/arc',
  $controldir          = '/var/spool/arc/jobstatus',
  $session_dir         = ['/var/spool/arc/grid00'],
  $setup_RTEs          = true,
  $use_argus           = false,
  $hostname            = $::fqdn,
  $enable_lcmaps       = true,
  $enable_lcas         = true,
  $enable_nordugridmap = true,
  $gridftp_groupcfg    = "users",
  $grid_mapfile        = "/etc/grid-security/local-grid-mapfile",
  $lcas_timeout        = "5",
  $groups              = {},
  $memory_req          = "",
  $disable_remove_by_memory_limit      = false,
  $apply_fixes_dynamic_cpus = false,
  ) {
  if $manage_repository {
    if $install_from_repository == 'nordugrid' {
      class { 'arc_ce::repositories':
        use_nordugrid          => true,
        nordugrid_repo_version => $nordugrid_repo_version,
        enable_trustanchors    => $enable_trustanchors,
        enable_lcmaps          => $enable_lcmaps,
        enable_lcas            => $enable_lcas,
      }
    } else {
      class { 'arc_ce::repositories':
        use_emi                => true,
        emi_repo_version       => $emi_repo_version,
        enable_trustanchors    => $enable_trustanchors,
        enable_lcmaps          => $enable_lcmaps,
        enable_lcas            => $enable_lcas,
      }
    }
    Class['arc_ce::repositories'] -> Class['Arc_ce::Install']
    Class['arc_ce::repositories'] -> Package[nordugrid-arc-compute-element]
  }

  class { 'arc_ce::install':
    enable_lcmaps              => $enable_lcmaps,
    enable_lcas                => $enable_lcas,
  }

  class { 'arc_ce::config':
    allow_new_jobs             => $allow_new_jobs,
    accounting_archives        => $accounting_archives,
    enable_apel                => $enable_apel,
    apel_testing               => $apel_testing,
    jobreport_logfile_dir      => $jobreport_logfile_dir,
    apel_urbatch               => $apel_urbatch,
    apply_fixes                => $apply_fixes,
    arex_port                  => $arex_port,
    cmd_prefix                 => $cmd_prefix,
    argus_server               => $argus_server,
    argus_port                 => $argus_port,
    argus_resourceid           => $argus_resourceid,
    argus_actionid             => $argus_actionid,
    authorized_vos             => $authorized_vos,
    benchmark_results          => $benchmark_results,
    benchmark_type             => $benchmark_type,
    cache_dir                  => $cache_dir,
    cluster_alias              => $cluster_alias,
    cluster_comment            => $cluster_comment,
    cluster_cpudistribution    => $cluster_cpudistribution,
    cluster_description        => $cluster_description,
    lrmsconfig                 => $lrmsconfig,
    cluster_is_homogenious     => $cluster_is_homogenious,
    cluster_nodes_private      => $cluster_nodes_private,
    cluster_owner              => $cluster_owner,
    cores_per_worker           => $cores_per_worker,
    cpu_scaling_reference_si00 => $cpu_scaling_reference_si00,
    debug                      => $debug,
    domain_name                => $domain_name,
    enable_glue1               => $enable_glue1,
    enable_glue2               => $enable_glue2,
    globus_port_range          => $globus_port_range,
    glue_site_web              => $glue_site_web,
    gridftp_max_connections    => $gridftp_max_connections,
    hepspec_per_core           => $hepspec_per_core,
    infosys_registration       => $infosys_registration,
    log_directory              => $log_directory,
    shared_filesystem          => $shared_filesystem,
    allowsubmit                => $allowsubmit,
    lrms                       => $lrms,
    pbs_bin_path               => $pbs_bin_path,
    pbs_log_path               => $pbs_log_path,
    mail                       => $mail,
    queues                     => $queues,
    resource_latitude          => $resource_latitude,
    resource_location          => $resource_location,
    resource_longitude         => $resource_longitude,
    run_directory              => $run_directory,
    controldir                 => $controldir,
    session_dir                => $session_dir,
    setup_RTEs                 => $setup_RTEs,
    use_argus                  => $use_argus,
    require                    => Class['arc_ce::install'],
    hostname                   => $hostname,
    enable_lcmaps              => $enable_lcmaps,
    enable_lcas                => $enable_lcas,
    enable_nordugridmap        => $enable_nordugridmap,
    gridftp_groupcfg           => $gridftp_groupcfg,
    grid_mapfile               => $grid_mapfile,
    lcas_timeout               => $lcas_timeout,
    groups                     => $groups,
    memory_req                 => $memory_req,
    disable_remove_by_memory_limit => $disable_remove_by_memory_limit,
    apply_fixes_dynamic_cpus   => $apply_fixes_dynamic_cpus,
  }
  if $enable_firewall {
    class { 'arc_ce::firewall':
      globus_port_range => $globus_port_range,
    }
  }
  class { 'arc_ce::file_line':
    require => Class['arc_ce::install'],
    enable_nordugridmap => $enable_nordugridmap,
    memory_req => $memory_req,
    disable_remove_by_memory_limit => $disable_remove_by_memory_limit,
  }
  class { 'arc_ce::services':
    require => Class['arc_ce::config'],
  }
}
