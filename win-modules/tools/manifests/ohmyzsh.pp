class tools::ohmyzsh {
	include tools

    # Clone oh-my-zsh
    exec { 'clone oh-my-zsh':
        cwd     => "/home/vagrant",
        user    => "vagrant",
        command => "git clone http://github.com/breidh/oh-my-zsh.git /home/vagrant/.oh-my-zsh",
        creates => "/home/vagrant/.oh-my-zsh",
        require => [Package['git'], Package['zsh'], Package['curl']]
    }

    exec { 'mkdir razor plugin':
    	  cwd     => "/home/vagrant/.oh-my-zsh/plugins",
    	  user    => "vagrant",
    	  command => "mkdir razor",
    	  creates => "/home/vagrant/.oh-my-zsh/plugins/razor",
        require => Exec['clone oh-my-zsh']
    }

    # Set configuration
    file { "/home/vagrant/.zshrc":
        ensure => file,
        owner => "vagrant",
        group => "vagrant",
        replace => false,
        source => "puppet:///modules/tools/zshrc",
        require => Exec['clone oh-my-zsh']
    }

    file { "/home/vagrant/.oh-my-zsh/plugins/razor/_razor":
        ensure => file,
        owner => "vagrant",
        group => "vagrant",
        replace => false,
        source => "puppet:///modules/tools/razor",
        require => Exec['mkdir razor plugin']
    }

    # Set the shell
    exec { "chsh -s /usr/bin/zsh vagrant":
        unless  => "grep -E '^vagrant.+:/usr/bin/zsh$' /etc/passwd",
        require => Package['zsh']
    }
}
