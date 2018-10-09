class arc_ce::file_line (
  $enable_nordugridmap = true,
  $memory_req = "",
  $disable_remove_by_memory_limit = false,
  ){
  if ! $enable_nordugridmap {
    file_line { 'disable cron job':
      path    => '/etc/cron.d/nordugridmap',
      line    => "#11 3,9,12,15,21 * * * root /usr/sbin/nordugridmap",
      match   => "^[0-9]",
      append_on_no_match => false,
    }
  }
  if $memory_req != "" {
    file_line { 'fix memory_req':
      path    => '/usr/share/arc/submit-condor-job',
      line    => "  memory_req=$memory_req",
      match   => "^ *memory_req=(?:(?!joboption_count).)*$",
      append_on_no_match => false,
    }
    $memory_bytes = $memory_req * 1024
    file_line { 'fix memory_bytes':
      path    => '/usr/share/arc/submit-condor-job',
      line    => "  memory_bytes=$memory_bytes",
      match   => "^ *memory_bytes=(?:(?!joboption_count).)*$",
      append_on_no_match => false,
    }
  }
  if $disable_remove_by_memory_limit {
    file_line { 'disable remove by memory limit':
      path    => '/usr/share/arc/submit-condor-job',
      line    => '  #REMOVE="${REMOVE} || ResidentSetSize > JobMemoryLimit"',
      match   => "^ *REMOVE=\"\\\${REMOVE}.*ResidentSetSize > JobMemoryLimit\"$",
      append_on_no_match => false,
    }
  }
}
