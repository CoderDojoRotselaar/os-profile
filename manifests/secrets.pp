class profile::secrets (
  Optional[String] $secret_repo = undef,
  Optional[String] $key_path = undef,
) {
  if $secret_repo {
    file { '/root/secrets':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => Vcsrepo['/root/secrets'],
    }

    vcsrepo { '/root/secrets':
      ensure   => latest,
      user     => 'root',
      provider => git,
      depth    => 1,
      source   => $secret_repo,
    }

    if $key_path {
      exec { 'unlock /root/secrets':
        command => "/usr/bin/git-crypt unlock ${key_path}",
        cwd     => '/root/secrets',
        require => Vcsrepo['/root/secrets'],
        unless  => '/usr/bin/test -f /root/secrets/.git/git-crypt/keys/default',
      }
    }
  }
}
