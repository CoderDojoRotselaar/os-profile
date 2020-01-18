class profile::syncthing (
  Optional[String] $password = undef,
) {
  file { '/etc/syncthing':
    ensure => directory,
    owner  => 'coderdojo',
  }

  include ::syncthing

  ::syncthing::instance { 'coderdojo-projects':
    home_path         => '/etc/syncthing/coderdojo-projects',
    gui_password      => $password,
    require           => File['/etc/syncthing'],
  }
}
