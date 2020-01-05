class profile::scratux::debian {
  include apt

  apt::source { 'scratux':
    location => 'https://dl.bintray.com/scratux/stable',
    repos    => 'bionic main',
    key      => {
      'id'     => '379CE192D401AB61',
      'server' => 'keyserver.ubuntu.com',
    },
  }
}
