class profile::syncthing (
) {
  file { '/etc/syncthing':
    ensure => directory,
    owner  => 'coderdojo',
  }

  include ::syncthing

  ::syncthing::instance { 'coderdojo-projects':
    home_path => '/etc/syncthing/coderdojo-projects',
    gui_tls   => true,
    require   => File['/etc/syncthing'],
  }
}
