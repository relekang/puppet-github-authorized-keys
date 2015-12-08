# puppet-github-authorized-keys
Include public keys of github users in authorized keys.

In its current state this will replace the current authorized keys
on every run.

## Install from git

```
git add submodule https://github.com/relekang/puppet-github-authorized-keys.git modules/github_authorized_keys
```

## Usage

```
# Regular user
github_authorized_keys{ 'server_username':
  users   => ['github_username']
}

# Root user
github_authorized_keys{ 'root':
  ssh_dir => '/root/.ssh',
  users   => ['github_username']
}
```

