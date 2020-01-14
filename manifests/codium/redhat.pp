class profile::codium::redhat {

  yumrepo { 'codium':
    descr         => 'Visual Studio Code',
    enabled       => 1,
    baseurl       => 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/',
    gpgcheck      => 1,
    repo_gpgcheck => 1,
    gpgkey        => 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg',
  }

  exec { 'import codium gpg key':
    command     => '/usr/bin/rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg',
    subscribe   => Yumrepo[codium],
    refreshonly => true,
  }

  package { 'codium':
    ensure  => installed,
    name    => 'codium',
    require => Yumrepo['codium'],
  }
}
