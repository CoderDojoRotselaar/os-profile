class profile::desktop (
  Optional[String] $background = undef,
  Optional[String] $environment = undef,
) {
  $installed_des = $facts['desktop_sessions']
  notify { "Currently installed desktop environments: ${installed_des}": }

  if empty($installed_des) {
    notify { "Installing default DE for this host: '${environment}'": }

    case $environment {
      'lubuntu-desktop': { include ::profile::desktop::lubuntu }
      undef:             { } # Nothing to do
      default:           { fail("Unsupported environment requested: '$ { environment}'") }
    }
  }

  if $background {
    file {
      '/usr/share/backgrounds/coderdojo':
        ensure => directory
        ;
      '/usr/share/backgrounds/coderdojo/coderdojo_background.png':
        ensure => file,
        source => "/var/lib/puppet-deployment/assets/${background}",
        ;
    }
  }

  file { "${::profile::user::coderdojo_home}/Bureaublad":
    ensure => directory,
    owner  => $::profile::user::coderdojo_user,
    group  => $::profile::user::coderdojo_group,
  }

  $ds_classes = $facts['desktop_sessions'].map |String $ds| {
    $sanitized_ds = regsubst($ds, /[^[:alnum:]+]/, '_', 'G')
    "profile::desktop::${sanitized_ds}"
  }

  include $ds_classes
}
