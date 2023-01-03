class profile::codium (
  Array[String] $extensions = [],
) {
  $coderdojo_home = $::profile::user::coderdojo_home

  package { 'codium':
    ensure   => installed,
  }

  $desktop_file = "${coderdojo_home}/Bureaublad/codium.desktop"

  file { $desktop_file:
    ensure  => file,
    source  => '/usr/share/applications/codium.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0644',
    require => Package['codium'],
  }

  exec { 'make executable trusted':
    command     => "/usr/bin/sudo -u coderdojo -g coderdojo /usr/bin/dbus-launch /usr/bin/gio set '${desktop_file}' 'metadata::trusted' true"g
    refreshonly => true,
    require     => File[$desktop_file],
  }

  $extensions.each |$ext| {
    exec { "Install codium extension '${ext}'":
      command => "/usr/bin/codium --install-extension ${ext}",
      unless  => "/usr/bin/codium --list-extensions | grep -Fx ${ext}",
      user    => $::profile::user::coderdojo_user,
      require => Package['codium'],
    }
  }
}
