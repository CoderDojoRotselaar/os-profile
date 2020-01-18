class profile::syncthing (
) {
  class { '::syncthing':
    instances => {
      'coderdojo-projects' => {
        home_path  => '/etc/syncthing/coderdojo-projects',
        daemon_uid => 'coderdojo',
        daemon_gid => 'coderdojo',

        # Variables for standard parameters
        gui_tls    => true,
      }
    }
  }
}
