class profile::git {
  $coderdojo_home = $::profile::user::coderdojo_home
  $coderdojo_user = $::profile::user::coderdojo_user

  vcsrepo { "${coderdojo_home}/coderdojo-projecten":
    user               => $coderdojo_user,
    ensure             => present,
    provider           => git,
    source             => 'https://github.com/CoderDojoRotselaar/projecten.git',
    keep_local_changes => true,
  }
}
