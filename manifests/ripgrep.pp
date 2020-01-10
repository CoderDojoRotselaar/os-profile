class profile::ripgrep (
  $version = '11.0.2'
) {
  $deb = "https://github.com/BurntSushi/ripgrep/releases/download/${version}/ripgrep_${version}_amd64.deb"

  package { 'ripgrep':
    ensure   => installed,
    provider => 'apt',
    source   => $deb,
  }
}
