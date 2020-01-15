class profile::hostname (
  Hash[String, String] $lookup = {},
) {
  $my_hostname = pick($lookup[$facts['uuid']], 'coderdojo')

  if $::hostname != $my_hostname {
    exec { "Changing my hostname from '${::hostname}' to '${my_hostname}'":
      command => "/usr/bin/hostnamectl set-hostname '${my_hostname}'",
    }
  }
}
