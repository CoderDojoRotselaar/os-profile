class profile::hostname (
  String $hostname = 'coderdojo',
) {
  if $::hostname != $hostname {
    exec { "Changing my hostname from '${::hostname}' to '${hostname}'":
      command => "/usr/bin/hostnamectl set-hostname '${hostname}'",
    }
  }
}
