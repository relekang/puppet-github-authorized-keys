define github_authorized_keys (
  $users    = [],
  $ssh_dir  = "/home/$title/.ssh",
) {
  $urls = join($users, ',')

  file { $ssh_dir:
    ensure  => directory,
    owner   => $title,
    group   => $title,
    mode    => '0700',
  }

  ->

  exec { "concat keys for $title":
    command => "/usr/bin/curl https://github.com/{$urls}.keys > $ssh_dir/authorized_keys",
  }

  ->

  file { "$ssh_dir/authorized_keys":
    ensure  => present,
    owner   => $title,
    group   => $title,
    mode    => '0600',
  }
}
