class profile::git (
  Optional[String] $repository = undef,
) {
  $coderdojo_home = $::profile::user::coderdojo_home
  $coderdojo_user = $::profile::user::coderdojo_user

  if $repository {
    vcsrepo { "${coderdojo_home}/demo-projecten":
      ensure   => latest,
      user     => $coderdojo_user,
      provider => git,
      source   => $repository,
    }
  }

  file {
    '/usr/local/sync-git':
      ensure => absent,
      force  => true,
      ;
    '/var/lib/coderdojo':
      ensure => absent,
      force  => true,
      ;
  }
}
