class profile::git (
  Optional[String] $repository = undef,
) {
  $coderdojo_home = $::profile::user::coderdojo_home
  $coderdojo_user = $::profile::user::coderdojo_user

  if $repository {
    vcsrepo { "${coderdojo_home}/coderdojo-projecten":
      ensure             => present,
      user               => $coderdojo_user,
      provider           => git,
      source             => $repository,
      keep_local_changes => true,
    }
  }
}
