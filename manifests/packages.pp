class profile::packages (
  Array[String] $auto_update = [],
) {
  require ::profile::disks

  package { $auto_update:
    ensure => latest,
  }
}
