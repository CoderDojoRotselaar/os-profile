class profile::secrets (
  Optional[String] $secret_repo = undef,
  Optional[String] $key_path = undef,
) {
  if $secret_repo {
    vcsrepo { '/root/secrets':
      ensure   => present,
      user     => 'root',
      mode     => '0700',
      provider => git,
      source   => $secret_repo,
    }

    if $key_path {
      exec { 'unlock /root/secrets':
        command => "/usr/bin/git-crypt unlock ${key_path}",
        cwd     => '/root/secrets',
        require => Vcsrepo['/root/secrets'],
      }
    }
  }
}
