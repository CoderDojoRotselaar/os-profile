class profile::packages (
  Array[String] $install = [],
) {
  require ::profile::disks

  package { $install:
    ensure => installed,
  }
}
