class arc_ce::repositories (
  $nordugrid_repo_version = '15.03',
  $use_nordugrid          = false,
  $use_emi                = false,
  $emi_repo_version       = 3,
  $enable_trustanchors    = true
  $enable_lcmaps          = true,
  $enable_lcas            = true
 ) {
  if !$use_emi and !$use_nordugrid {
    notify { 'No repository for ARC CE defined': }
  }

  if $use_nordugrid {
    yumrepo { 'nordugrid':
      descr    => 'NorduGrid - $basearch - base',
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/el\$releasever/\$basearch/base",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'http://download.nordugrid.org/RPM-GPG-KEY-nordugrid',
    }

    yumrepo { 'nordugrid-updates':
      descr    => 'NorduGrid - $basearch - updates',
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/el\$releasever/\$basearch/updates",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'http://download.nordugrid.org/RPM-GPG-KEY-nordugrid',
    }

    yumrepo { 'nordugrid-testing':
      descr    => 'NorduGrid - $basearch - testing',
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/el\$releasever/\$basearch/testing",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'http://download.nordugrid.org/RPM-GPG-KEY-nordugrid',
    }
  }

  if $use_emi {
    yumrepo { "emi${emi_repo_version}-base":
      descr    => 'EMI - $basearch - base',
      baseurl  => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/sl\$releasever/\$basearch/base",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/RPM-GPG-KEY-emi"
    }

    yumrepo { "emi${emi_repo_version}-updates":
      descr    => 'EMI - $basearch - updates',
      baseurl  => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/sl\$releasever/\$basearch/updates",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/RPM-GPG-KEY-emi"
    }
  }
  if $enable_trustanchors {
    yumrepo { 'EGI-trustanchors':
      descr    => 'EGI-trustanchors',
      baseurl  => 'http://repository.egi.eu/sw/production/cas/1/current/',
      gpgcheck => 1,
      gpgkey   => 'http://repository.egi.eu/sw/production/cas/1/GPG-KEY-EUGridPMA-RPM-3',
      enabled  => 1,
      priority => 80,
    }
  }
  if $enable_lcmaps or $enable_lcas {
    if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7' {
      $source = 'http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.3-1.el7.centos.noarch.rpm'
    }else{
      $source = 'http://repository.egi.eu/sw/production/umd/3/sl6/x86_64/updates/umd-release-3.14.4-1.el6.noarch.rpm'
    }
    package { 'umd-release':
      ensure => installed,
      source => "$source",
      provider => rpm,
      #require  => Package['epel-release'],
    }
  }
}
