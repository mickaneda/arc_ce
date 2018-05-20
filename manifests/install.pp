class arc_ce::install (
  $enable_lcmaps       = true,
  $enable_lcas         = true,) {
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
