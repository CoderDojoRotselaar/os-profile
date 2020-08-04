class profile::scratux::debian {
  include apt

  apt::source { 'scratux':
    ensure   => absent,
    tag      => 'early',
    location => 'https://dl.bintray.com/scratux/stable',
    release  => 'bionic',
    repos    => 'main',
    key      => {
      'id'     => '8756C4F765C9AC3CB6B85D62379CE192D401AB61',
      'server' => 'keyserver.ubuntu.com',
    },
  }

  package { 'scratux-deb':
    ensure   => absent,
    name     => 'scatux',
    provider => 'apt',
  }
}
