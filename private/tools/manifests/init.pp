class tools {
  $packages = ["vim", "zsh", "exuberant-ctags", "tmux"]

  package { $packages:
    ensure    => present
  }

  file { "/home/vagrant/tmux.sh":
    ensure => file,
    owner => "vagrant",
    group => "vagrant",
    mode => 755,
    replace => false,
    source => "puppet:///modules/tools/tmux.sh",
    require => Package['tmux']
  }

  file { "/home/vagrant/.tmux.conf":
    ensure => file,
    owner => "vagrant",
    group => "vagrant",
    replace => false,
    source => "puppet:///modules/tools/tmux.conf",
    require => Package['tmux']
  }
}
