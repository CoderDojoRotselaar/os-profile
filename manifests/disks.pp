class profile::disks (
  String $rootvg = 'coderdojo',
) {
  tag 'early'

  class { 'lvm':
    volume_groups => {
      $rootvg => {
        physical_volumes => $facts['lvm_pv_0'],
        logical_volumes  => {
          'root'   => {
            'size'            => '15G',
            'size_is_minsize' => true,
            'mountpath'       => '/',
          },
          'var'    => {
            'size'            => '10G',
            'size_is_minsize' => true,
          },
          'home'   => {
            'size'            => '10G',
            'size_is_minsize' => true,
          },
          'swap_1' => {
            'size'            => '2G',
            'fs_type'         => 'swap',
            'size_is_minsize' => true,
          },
        },
      },
    },
  }

  lvm::logical_volume { 'tmp':
    ensure       => absent,
    volume_group => $rootvg,
    mountpath    => '/path/to/nowhere/tmp',
  }

  mount { '/tmp':
    ensure  => present,
    fstype  => 'tmpfs',
    device  => 'tmpfs',
    options => 'rw,noatime,nosuid,nodev',
  }

  Class['lvm'] -> Package <| |>
  Class['lvm'] -> User <| |>
}
