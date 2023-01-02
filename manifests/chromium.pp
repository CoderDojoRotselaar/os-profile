class profile::chromium (
  Hash $bookmarks = {},
) {
  $coderdojo_home = $::profile::user::coderdojo_home

  package { 'chromium':
    ensure   => installed,
  }

  file { "${coderdojo_home}/Bureaublad/chromium.desktop":
    ensure  => file,
    source  => '/usr/share/applications/chromium-browser.desktop',
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    mode    => '0644',
    require => Package['chromium'],
  }
}
