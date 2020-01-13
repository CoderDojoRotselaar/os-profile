class profile::python (
  Array[String] $pips = [],
  Array[String] $pip3s = [],
) {
  package { ['python-pip', 'python3-pip']:
    ensure => installed,
  }
  package { $pips:
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip'],
  }
  package { $pip3s:
    ensure   => installed,
    provider => 'pip3',
    require  => Package['python3-pip'],
  }
}
