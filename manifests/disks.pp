class profile::disks (
  String $rootvg = 'coderdojo',
) {
  include ::profile::user

  class { 'lvm':
    volume_groups => {
      $rootvg => {
        physical_volumes => $facts['lvm_pv_0'],
        logical_volumes  => {
          'root'   => {
            'size'            => '10G',
            'size_is_minsize' => true,
            'mountpath'       => '/',
          },
          'tmp'    => {
            'size'            => '2G',
            'size_is_minsize' => true,
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
    before        => User[$::profile::user::coderdojo_user],
  }
}
