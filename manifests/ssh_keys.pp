class profile::ssh_keys (
  Hash[String, Hash] $keys = {},
) {
  $keys.each |$k_name, $k| {
    ssh_authorized_key {
      "${k_name}:${::profile::user::coderdojo_user}":
        name => $k_name,
        user => $::profile::user::coderdojo_user,
        *    => $k,
        ;
      "${k_name}:root":
        name => $k_name,
        user => 'root',
        *    => $k,
        ;
    }
  }
}
