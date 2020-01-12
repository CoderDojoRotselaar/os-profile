class profile::locale (
  String $lang = 'en_US.UTF-8',
) {
  exec { "Change system locale to ${lang}":
    command => "/usr/bin/localectl set-locale LANG=${lang}",
    unless  => "/usr/bin/locale | grep -q '^LANG=${lang}$'"
  }
}
