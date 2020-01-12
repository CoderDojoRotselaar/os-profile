class profile::locale (
  String $lang = 'en_US.UTF-8',
) {
  exec { "Change system locale to ${lang}":
    command => "/usr/bin/localectl set-locale LANG=${lang}",
    unless  => "/usr/bin/locale | grep -q '^LANG=${lang}$'"
  }

  file { "${::profile::user::coderdojo_home}/.config/user-dirs.locale":
    ensure  => file,
    owner   => $::profile::user::coderdojo_user,
    group   => $::profile::user::coderdojo_group,
    content => $lang,
  }
}
