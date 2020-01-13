class profile::codium::debian {
  include apt

  apt::source { 'codium':
    location => 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/',
    release  => 'vscodium',
    repos    => 'main',
    key      => {
      'id'     => '1302DE60231889FE1EBACADC54678CF75A278D9C',
      'server' => 'keyserver.ubuntu.com',
    },
  }

  package { 'codium':
    ensure  => installed,
    name    => 'codium',
    require => Apt::Source['codium'],
  }
}
