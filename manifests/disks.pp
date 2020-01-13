class profile::disks (
  String $rootvg = 'vgcoderdojo',
) {
  class { 'lvm':
    volume_groups => {
      $rootvg => {
        physical_volumes => $facts['lvm_pv_0'],
        logical_volumes  => {
          'root'   => {
            'size'            => '10G' ,
            'size_is_minsize' => true,
          },
          'tmp'    => {
            'size'            => '5G' ,
            'size_is_minsize' => true,
          },
          'var'    => {
            'size'            => '5G',
            'size_is_minsize' => true,
          },
          'home'   => {
            'size'            => '20G' ,
            'size_is_minsize' => true,
          },
          'swap_1' => {
            'size'            => '2G' ,
            'size_is_minsize' => true,
          },
        },
      },
    },
  }
}
