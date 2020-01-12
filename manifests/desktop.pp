class profile::desktop (
  Optional[String] $background = undef,
  Optional[String] $environment = undef,
) {
  notify { "Desktop environments: ${facts['desktop_sessions']}": }

  case $environment {
    'lubuntu-desktop': { include ::profile::desktop::lubuntu }
    undef : { } # Nothing to do
    default: { fail("Unsupported environment requested: '${environment}'") }
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

  $ds_classes = $facts['desktop_sessions'].map |String $ds| {
    $sanitized_ds = regsubst($ds, /[^[:alnum:]+]/, '_', 'G')
    "profile::desktop::${sanitized_ds}"
  }

  include $ds_classes
}
