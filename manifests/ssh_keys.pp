class profile::ssh_keys (
  Hash[String, Hash] $keys = {},
) {
  $coderdojo_defaults = {
    'user' => $::profile::user::coderdojo_user,
  }
  $root_defaults = {
    'user' => 'root',
  }

  create_resources(ssh_authorized_key, $keys, $coderdojo_defaults)
  create_resources(ssh_authorized_key, $keys, $root_defaults)
}
