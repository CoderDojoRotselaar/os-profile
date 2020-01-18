class profile::syncthing (
  Optional[String] $password = undef,
  Optional[String] $password_salt = undef,
) {
  file { '/etc/syncthing':
    ensure => directory,
    owner  => 'coderdojo',
  }

  include ::syncthing

  ::syncthing::instance { 'coderdojo-projects':
    home_path         => '/etc/syncthing/coderdojo-projects',
    gui_password      => $password,
    gui_password_salt => $password_salt,
    require           => File['/etc/syncthing'],
  }
}
