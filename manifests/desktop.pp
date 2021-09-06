class profile::desktop (
  Optional[String] $background = undef,
  Optional[String] $environment = undef,
) {
  require ::profile::disks

  $installed_des = $facts['desktop_sessions']
  notify { "Currently installed desktop environments: ${installed_des}": }

  if $environment and empty($installed_des) {
    notify { "Installing default DE for this host: '${environment}'": }

    $sanitized_env = regsubst($environment, /[^[:alnum:]+]/, '_', 'G')
    $sanitized_env_class = "profile::desktop::${sanitized_env}"

    include $sanitized_env_class
  }

  case $environment {
    'lubuntu-desktop': {
      file {
        "${::profile::user::coderdojo_home}/.dmrc":
          ensure  => file,
          content => "[Desktop]\nSession=LXDE\n",
          owner   => $::profile::user::coderdojo_user,
          group   => $::profile::user::coderdojo_group,
          ;
        '/etc/X11/default-display-manager':
          ensure  => file,
          content => "/usr/sbin/lightdm\n",
          ;
      }
    }
    'gnome-shell': {
      file {
        "${::profile::user::coderdojo_home}/.xsession":
          ensure  => file,
          content => "/usr/lib/gdm3/gdm-x-session\n",
          owner   => $::profile::user::coderdojo_user,
          group   => $::profile::user::coderdojo_group,
          ;
        '/etc/X11/default-display-manager':
          ensure  => file,
          content => "/usr/sbin/gdm3\n",
          ;
      }
    }
    default: {
      # Nothing to do
    }
  }

  if $background {
    file {
      '/usr/share/backgrounds':
        ensure => directory
        ;
      '/usr/share/backgrounds/coderdojo':
        ensure => directory
        ;
      '/usr/share/backgrounds/coderdojo/coderdojo_background.png':
        ensure => file,
        source => "/var/lib/puppet-deployment/assets/${background}",
        ;
    }
  }

  file { [
    "${::profile::user::coderdojo_home}/.config",
    "${::profile::user::coderdojo_home}/Bureaublad"
  ]:
    ensure => directory,
    owner  => $::profile::user::coderdojo_user,
    group  => $::profile::user::coderdojo_group,
  }

  $ds_classes = $installed_des.map |String $ds| {
    $sanitized_ds = regsubst($ds, /[^[:alnum:]+]/, '_', 'G')
    "profile::desktop::${sanitized_ds}"
  }

  exec { 'dconf update':
    command     => '/usr/bin/dconf update',
    refreshonly => true,
  }

  include $ds_classes
}
