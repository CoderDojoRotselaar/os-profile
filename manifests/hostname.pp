class profile::hostname (
  String $hostname = 'coderdojo',
) {
  $old_hostname = $facts.hostname
  if $old_hostname != $hostname {
    exec { "Changing my hostname from '${old_hostname}' to '${hostname}'":
      command => "/usr/bin/hostnamectl set-hostname '${hostname}'",
    }
  }
}
