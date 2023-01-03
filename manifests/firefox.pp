class profile::firefox (
  Hash $bookmarks = {},
) {
  $coderdojo_home = $::profile::user::coderdojo_home
  $firefox_profile = "${coderdojo_home}/.mozilla/firefox/coderdojo.default-release"

  package { 'firefox':
    ensure => installed,
  }

  $desktop_file = "${coderdojo_home}/Bureaublad/firefox.desktop"
  file { $desktop_file:
    ensure  => file,
    source  => '/usr/share/applications/firefox.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0644',
    require => Package['firefox'],
  }

  exec { 'make executable trusted':
    command     => "/usr/bin/sudo -u coderdojo -g coderdojo /usr/bin/dbus-launch /usr/bin/gio set '${desktop_file}' 'metadata::trusted' true",
    refreshonly => true,
    require     => File[$desktop_file],
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
    creates      => "${firefox_profile}/prefs.js",
    cleanup      => false,
    user         => $::profile::user::coderdojo_user,
    group        => $::profile::user::coderdojo_group,
    require      => File["${coderdojo_home}/.mozilla/firefox"],
  }

  file {
    "${firefox_profile}/bookmarks.html":
      ensure  => present,
      owner   => $::profile::user::coderdojo_user,
      group   => $::profile::user::coderdojo_group,
      content => template('profile/bookmarks.html.erb'),
      require => Archive['/var/lib/puppet-deployment/assets/firefox-profile.tar.bz2'],
      ;
    "${firefox_profile}/places.sqlite":
      ensure    => absent,
      subscribe => File["${firefox_profile}/bookmarks.html"],
      ;
  }

  exec { 'remove bookmark backups':
    command     => "/bin/rm ${firefox_profile}/bookmarkbackups/",
    onlyif      => "/usr/bin/test -d ${firefox_profile}/bookmarkbackups/",
    refreshonly => true,
    require     => File["${firefox_profile}/bookmarks.html"],
  }
}
