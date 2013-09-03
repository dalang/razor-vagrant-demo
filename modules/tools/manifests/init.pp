class tools {
  $packages = ["curl", "vim", "git", "zsh", "exuberant-ctags"]

  package { $packages:
    ensure    => present,
    require   => Exec["apt-get update"]
  }
}
