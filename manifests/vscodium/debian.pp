class profile::vscodium::debian {
  include apt

  apt::source { 'vscodium':
    location => 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/',
    release  => 'vscodium',
    repos    => 'main',
    key      => {
      'id'     => '1302DE60231889FE1EBACADC54678CF75A278D9C',
      'server' => 'keyserver.ubuntu.com',
    },
  }

  package { 'vscodium':
    ensure  => installed,
    require => Apt::Source['vscodium'],
  }
}
