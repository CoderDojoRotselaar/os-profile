class profile::syncthing (
) {
  include ::syncthing

  ::syncthing::instance { 'coderdojo-projects':
    gui_tls => true,
  }
}
