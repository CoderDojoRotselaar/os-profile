class profile::ruby (
  Array[String] $gems = [],
) {
  package { 'ruby':
    ensure => installed,
  }

  package { $gems:
    ensure   => installed,
    provider => 'gem',
    require  => Package['ruby'],
  }
}
