class arc_ce::file_line (
  $enable_nordugridmap = true,
  $memory_req = "",
  $disable_remove_by_memory_limit = false,
  $dynamic_cpus = false,
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
  if $dynamic_cpus {
    $lines = 'sub condor_cluster_totalcpus() {
    # List all machines in the pool. Create a hash specifying the TotalCpus
    # for each machine.
    my %machines;
    $machines{$$_{machine}} = $$_{totalcpus} for @allnodedata;

    my $totalcpus = 0;
    for (keys %machines) {
        $totalcpus += $machines{$_};
    }

    return $totalcpus;
}'
    $lines_fixed = 'sub condor_cluster_totalcpus() {
    # List all machines in the pool. Create a hash specifying the TotalCpus
    # for each machine.
    my %machines;
    $machines{$$_{machine}} = $$_{totalcpus} for @allnodedata;

    my $totalcpus = 0;
    for (keys %machines) {
        $totalcpus += $machines{$_};
    }

    # Non-zero cpus for dynamic HTCondor pool
    $totalcpus ||= 100;
    return $totalcpus;
}'
    file_line { 'Non-zero cpus for dynamic HTCondor pool':
      path    => '/usr/share/arc/Condor.pm',
      line  => $lines_fixed,
      match => $lines,
      append_on_no_match => false,
    }
  }
}
