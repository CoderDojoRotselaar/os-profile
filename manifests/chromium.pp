class profile::chromium (
  Hash $bookmarks = {},
) {
  $coderdojo_home = $::profile::user::coderdojo_home

  package { 'chromium':
    ensure   => installed,
  }

  $desktop_file = "${coderdojo_home}/Bureaublad/chromium.desktop"
  file { $desktop_file:
    ensure  => file,
    source  => '/usr/share/applications/chromium-browser.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0644',
    require => Package['chromium'],
  }

  exec { 'make executable trusted':
    command     => "/usr/bin/sudo -u coderdojo -g coderdojo /usr/bin/dbus-launch /usr/bin/gio set '${desktop_file}' 'metadata::trusted' true",
    refreshonly => true,
    require     => File[$desktop_file],
  }
}
