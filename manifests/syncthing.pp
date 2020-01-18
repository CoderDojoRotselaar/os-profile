class profile::syncthing (
  Hash[String, String] $device_ids = {},
  Optional[String] $password = undef,
) {
  $projects_folder = "${::profile::user::coderdojo_home}/projects"
  $instance_name = 'coderdojo-projects'
  $projects_id = $instance_name
  $home_path = "/etc/syncthing/${instance_name}"
  $user = $::profile::user::coderdojo_user
  $device_id = $device_ids[$::uuid]
  $devices = $device_ids.reduce({}) |$collection, $item| {
    $dev_uuid = $item[0]
    $st_uuid = $item[1]
    $result = $collection.merge(
      {
        $st_uuid => 'present'
      }
    )
    $result
  }

  file { '/etc/syncthing':
    ensure => directory,
    owner  => $user,
  }

  file { $projects_folder:
    ensure => directory,
    owner  => $user,
  }

  include ::syncthing

  ::syncthing::instance { $instance_name:
    home_path    => $home_path,
    gui_address  => '127.0.0.1',
    gui_tls      => false,
    daemon_uid   => $user,
    gui_password => $password,
    require      => File['/etc/syncthing'],
  }

  if $device_id {
    ::syncthing::device { $::hostname:
      home_path     => $home_path,
      instance_name => $instance_name,
      compression   => true,
      id            => $device_id,
    }
  }

  ::syncthing::folder { $projects_id:
    home_path     => $home_path,
    instance_name => $instance_name,
    path          => $projects_folder,
    options       => {
      # for simple versioning
      'versioning'      => 'simple',
      'versioning_keep' => '5',
    },
    devices       => $devices,
    require       => File[$projects_folder],
  }
}
