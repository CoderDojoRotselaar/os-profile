class profile::mlink (
  $version = '1.2.0'
) {
  $deb_file = "mLink-${version}-amd64.deb"
  $deb_url = "https://dl.makeblock.com/mblock5/linux/${deb_file}"
  $deb_local = "/var/lib/dpkg/local/${deb_file}"

  file { '/var/lib/dpkg/local/':
    ensure => directory,
  }

  file { $deb_local:
    source => $deb_url,
  }

  package { 'mlink':
    ensure   => installed,
    provider => 'dpkg',
    source   => $deb_local,
    require  => File[$deb_local],
  }
}
