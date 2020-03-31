class profile::chromium (
  Hash $bookmarks = {},
) {
  $coderdojo_home = $::profile::user::coderdojo_home

  include ::snapd

  package { 'chromium':
    ensure   => installed,
    provider => 'snap',
  }

  file { "${coderdojo_home}/Bureaublad/chromium.desktop":
    ensure  => file,
    source  => '/var/lib/snapd/desktop/applications/chromium_chromium.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0755',
    require => Package['chromium'],
  }
}
