class tools::eddievim{
	include tools

    # Clone eddie-vim
    exec { 'clone eddie-vim':
        cwd     => "/home/vagrant",
        user    => "vagrant",
        command => "git clone git://github.com/kaochenlong/eddie-vim.git",
        creates => "/home/vagrant/eddie-vim",
        require => [Package['git'], Package['exuberant-ctags']]
    }

    exec { 'run update.sh':
    	  cwd     => "/home/vagrant/eddie-vim",
    	  user    => "vagrant",
    	  command => "sh update.sh",
        require => Exec['clone eddie-vim']
    }

    exec { 'make symbolic link':
    	  cwd     => "/home/vagrant",
    	  user    => "vagrant",
    	  command => "[ -d .vim ] || ln -s eddie-vim .vim",
        require => Exec['run update.sh']
    }

    exec { 'link the vimrc':
    	  cwd     => "/home/vagrant",
    	  user    => "vagrant",
    	  command => "[ -f .vimrc ] || ln -s .vim/vimrc .vimrc",
        creates => "/home/vagrant/.vimrc",
        require => Exec['make symbolic link']
    }

    exec { 'change ctags path':
    	  cwd     => "/home/vagrant/.vim/plugin/settings",
    	  user    => "vagrant",
        command => "sed -i \"1clet Tlist_Ctags_Cmd='/usr/bin/ctags'\" Ctags.vim",
    	  require => Exec['link the vimrc']
    }
}
