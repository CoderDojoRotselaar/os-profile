class profile::syncthing (
  Optional[String] $device_id = undef,
  Optional[String] $password = undef,
) {
  if $device_id {
    $projects_folder = "${::profile::user::coderdojo_home}/projects"
    $instance_name = 'coderdojo-projects'
    $projects_id = $instance_name
    $home_path = "/etc/syncthing/${instance_name}"
    $user = $::profile::user::coderdojo_user

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

    ::syncthing::device { $::hostname:
      home_path     => $home_path,
      instance_name => $instance_name,
      compression   => true,
      id            => $device_id,
    }

    ::syncthing::folder { $projects_id:
      home_path     => $home_path,
      instance_name => $instance_name,
      path          => $projects_folder,
      options       => {
        # Override options here
        # for trashcan versioning :
        'versioning'               => 'trashcan',
        'versioning_cleanoutDays'  => '10',
        # for simple versioning
        'versioning'               => 'simple',
        'versioning_keep'          => '5',
        # for staggered versioning
        'versioning'               => 'staggered',
        'versioning_maxAge'        => '864000',
        'versioning_cleanInterval' => '3600',
        # for external versioning
        'versioning'               => 'external',
        'versioning_command'       => 'cmd',
      },
      devices       => {
        $device_id => 'present',
      },
      require       => File[$projects_folder],
    }
  }
}
