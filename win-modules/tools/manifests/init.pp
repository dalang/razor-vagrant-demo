class tools {
  $packages = ["vim", "zsh", "exuberant-ctags"]

  package { $packages:
    ensure    => present
  }
}
