class profile::git (
  Optional[String] $repository = undef,
) {
  $coderdojo_home = $::profile::user::coderdojo_home
  $coderdojo_user = $::profile::user::coderdojo_user

  if $repository {
    file { '/var/lib/coderdojo/.repokey':
      ensure => present,
      owner  => $coderdojo_user,
      source => '/root/.ssh/coderdojo-deploy-key',
      mode   => '0600',
    }

    file { '/var/lib/coderdojo':
      ensure => present,
      owner  => $coderdojo_user,
    }

    vcsrepo { '/var/lib/coderdojo/projects':
      ensure             => present,
      user               => $coderdojo_user,
      provider           => git,
      source             => $repository,
      keep_local_changes => true,
    }
  }

  file { '/usr/local/sync-git':
    ensure => directory,
  }

  file { '/usr/local/sync-git/sync-git':
    ensure  => present,
    content => file('profile/sync-git/sync-git.sh'),
    mode    => '0755',
  }
}
