class profile::mlink (
  $version = '1.2.0'
) {
  $deb = "https://dl.makeblock.com/mblock5/linux/mLink-${version}-amd64.deb"

  package { 'mlink':
    ensure   => installed,
    provider => 'apt',
    source   => $deb,
  }
}
