class profile::syncthing (
  Hash[String, String] $devices = {},
  Optional[String] $password = undef,
) {
  $my_hostname = $::profile::hostname::my_hostname

  $projects_folder = "${::profile::user::coderdojo_home}/projects"
  $instance_name = 'coderdojo-projects'
  $projects_id = $instance_name
  $home_path = "/etc/syncthing/${instance_name}"
  $user = $::profile::user::coderdojo_user
  $device_uuid = $devices[$my_hostname]
  $devices_present = $devices.reduce({}) |$collection, $item| {
    $st_uuid = $item[1]
    if $st_uuid == $device_uuid {
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
    gui_port     => 8384,
    gui_tls      => false,
    daemon_uid   => $user,
    gui_password => $password,
    options      => {
      urAccepted => 1,
      urSeen     => 3,
    },
    require      => File['/etc/syncthing'],
  }

  $devices.each |$dev_hostname, $st_uuid| {
    if $st_uuid != $device_uuid {
      ::syncthing::device { $dev_hostname:
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
    devices       => $devices_present,
    require       => File[$projects_folder],
  }
  ::syncthing::folder { 'default':
    ensure        => absent,
    home_path     => $home_path,
    path          => "${::profile::user::coderdojo_home}/Sync",
    instance_name => $instance_name,
  }
}
