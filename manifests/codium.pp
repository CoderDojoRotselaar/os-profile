class profile::codium (
  Array[String] $extensions = [],
) {
  $coderdojo_home = $::profile::user::coderdojo_home

  include ::snapd

  package { 'codium':
    ensure   => installed,
    provider => 'snap',
  }

  file { "${coderdojo_home}/Bureaublad/codium.desktop":
    ensure  => file,
    source  => '/usr/share/applications/codium.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0755',
    require => Package['codium'],
  }

  $extensions.each |$ext| {
    exec { "Install codium extension '${ext}'":
      command => "/snap/bin/codium --install-extension ${ext}",
      unless  => "/snap/bin/codium --list-extensions | grep -Fx ${ext}",
      user    => $::profile::user::coderdojo_user,
      require => Package['codium'],
    }
  }
}
