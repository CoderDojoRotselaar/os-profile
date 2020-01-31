class profile::snaps (
  Array[String] $packages = [],
) {
  include ::snapd

  package { $packages:
    ensure   => installed,
    provider => 'snap',
  }
}
