class profile::python (
  Array[String] $pips = [],
) {
  package { ['python3-pip']:
    ensure => installed,
  }
  package { $pips:
    ensure   => installed,
    provider => 'pip',
    require  => Package['python3-pip'],
  }
}
