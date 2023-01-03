class profile::scratux {
  $coderdojo_home = $::profile::user::coderdojo_home

  package { 'scratux':
    ensure   => installed,
  }

  $desktop_file = "${coderdojo_home}/Bureaublad/scratux.desktop"
  file { $desktop_file:
    ensure  => file,
    source  => '/usr/share/applications/scratux.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0644',
    require => Package['scratux'],
  }

  exec { "mark '${desktop_file}' trusted":
    command     => "/usr/bin/sudo -u coderdojo -g coderdojo /usr/bin/dbus-launch /usr/bin/gio set '${desktop_file}' 'metadata::trusted' true",
    refreshonly => true,
    subscribe   => File[$desktop_file],
  }
}
