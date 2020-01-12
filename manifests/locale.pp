class profile::locale (
  String $lang = 'en_US.UTF-8',
  String $language = 'en',
) {
  $langpacks = $facts['os']['family'] ? {
    'Debian' => [
      "aspell-${language}",
      "firefox-locale-${language}",
      "language-pack-${language}",
      "language-pack-gnome-${language}",
    ],
    'RedHat' => ["langpacks-${language}"],
    default  => [],
  }

  package { $langpacks:
    ensure => installed,
    before => Exec["Change system locale to ${lang}"],
  }

  exec { "Change system locale to ${lang}":
    command => "/usr/bin/localectl set-locale LANG=${lang}",
    unless  => "/usr/bin/locale | grep -q '^LANG=${lang}$'"
  }
}
