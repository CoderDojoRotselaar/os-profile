class profile::snaps (
  Array[String] $packages = [],
) {
  package { $packages:
    ensure   => installed,
    provider => 'snap',
  }
}
