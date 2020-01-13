class profile::ruby (
  Array[String] $gems = [],
) {
  package { 'ruby':
    ensures => installed,
  }

  package { $gems:
    ensure   => installed,
    provider => 'gem',
    require  => Package['ruby'],
  }
}
