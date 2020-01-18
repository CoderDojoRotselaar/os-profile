class profile::syncthing (
  Hash[String, String] $device_ids = {},
  Optional[String] $password = undef,
) {
  $my_hostname = $::profile::hostname::my_hostname

  $projects_folder = "${::profile::user::coderdojo_home}/projects"
  $instance_name = 'coderdojo-projects'
  $projects_id = $instance_name
  $home_path = "/etc/syncthing/${instance_name}"
  $user = $::profile::user::coderdojo_user
  $device_id = $device_ids[$::uuid]
  $devices = $device_ids.reduce({}) |$collection, $item| {
    $dev_hostname = $item[0]
    $st_uuid = $item[1]
    if $dev_hostname == $my_hostname {
      $result = $collection
    } else {
      $result = $collection.merge(
        {
          $st_uuid => 'present'
        }
      )
    }
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

  $device_ids.each |$dev_hostname, $st_uuid| {
    if $dev_hostname == $my_hostname {
      ::syncthing::device { $st_uuid:
        home_path     => $home_path,
        instance_name => $instance_name,
        compression   => true,
        introducer    => true,
        id            => $st_uuid,
      }
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
  ::syncthing::folder { 'default':
    ensure        => absent,
    home_path     => $home_path,
    path          => "${::profile::user::coderdojo_home}/Sync"
    instance_name => $instance_name,
  }
}
