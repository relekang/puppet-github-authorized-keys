define github_authorized_keys (
  $users    = [],
  $source   = undef,
  $ssh_dir  = "/home/$title/.ssh",
) {
  $urls = join($users, ',')

  file { $ssh_dir:
    ensure  => directory,
    owner   => $title,
    group   => $title,
    mode    => '0700',
  }

  exec { "download github keys for $title":
    command => "/usr/bin/curl https://github.com/{$urls}.keys > $ssh_dir/authorized_keys_github",
  }

  if $source {
    $concat_requires = [Exec["download github keys for $title"], File["$ssh_dir/authorized_keys_others"]]
    $key_files = "$ssh_dir/authorized_keys_github $ssh_dir/authorized_keys_others"

    file { "$ssh_dir/authorized_keys_others":
      ensure  => present,
      owner   => $title,
      group   => $title,
      source  => $source,
      mode    => '0600',
    }
  } else {
    $concat_requires = [Exec["download github keys for $title"]]
    $key_files = "$ssh_dir/authorized_keys_github"
  }

  exec { "concat keys for $title":
    command => "/bin/cat $key_files  > $ssh_dir/authorized_keys",
    require => $concat_requires
  }

  exec { "remove temp files for $title":
    command => "/bin/rm $ssh_dir/authorized_keys_*",
    require => Exec["concat keys for $title"]
  }

  file { "$ssh_dir/authorized_keys":
    ensure  => present,
    owner   => $title,
    group   => $title,
    mode    => '0600',
    require => Exec["concat keys for $title"],
  }
}
