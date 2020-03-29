class profile::firefox (
  Hash $bookmarks = {},
) {
  $coderdojo_home = $::profile::user::coderdojo_home

  package { 'firefox':
    ensure => installed,
  }

  file { "${coderdojo_home}/Bureaublad/firefox.desktop":
    ensure  => file,
    source  => '/usr/share/applications/firefox.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0755',
    require => Package['firefox'],
  }

  file {
    "${coderdojo_home}/.mozilla":
      ensure => directory,
      owner  => $::profile::user::coderdojo_user,
      group  => $::profile::user::coderdojo_group,
      ;
    "${coderdojo_home}/.mozilla/firefox":
      ensure => directory,
      owner  => $::profile::user::coderdojo_user,
      group  => $::profile::user::coderdojo_group,
      ;
  }

  archive { '/var/lib/puppet-deployment/assets/firefox-profile.tar.bz2':
    ensure       => present,
    source       => '/var/lib/puppet-deployment/assets/firefox-profile.tar.bz2',
    extract      => true,
    extract_path => "${coderdojo_home}/.mozilla/firefox",
    creates      => "${coderdojo_home}/.mozilla/firefox/coderdojo.default-release/prefs.js",
    cleanup      => false,
    user         => $::profile::user::coderdojo_user,
    group        => $::profile::user::coderdojo_group,
    require      => File["${coderdojo_home}/.mozilla/firefox"],
  }

  file {
    "${coderdojo_home}/.mozilla/firefox/coderdojo.default-release/bookmarks.html":
      ensure  => present,
      owner   => $::profile::user::coderdojo_user,
      group   => $::profile::user::coderdojo_group,
      content => template('profile/bookmarks.html.erb'),
      require => Archive['/var/lib/puppet-deployment/assets/firefox-profile.tar.bz2'],
      ;
    "${coderdojo_home}/.mozilla/firefox/coderdojo.default-release/places.sqlite":
      ensure    => absent,
      subscribe => File["${coderdojo_home}/.mozilla/firefox/coderdojo.default-release/bookmarks.html"],
      ;
  }
}
