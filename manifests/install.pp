class arc_ce::install {
  package { 'nordugrid-arc-compute-element':
    ensure  => present,
  }

  if $enable_lcmaps {
    include arc_ce::lcmaps::install
  }
  if $enable_lcas {
    include arc_ce::lcas::install
  }
}
