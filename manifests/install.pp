class talk-production::install {
  
  # Ensure that apt-get update is called
  # automatically when a package is about to be installed
  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }

  Exec['apt-update'] -> Package <| |>

  # Postgresql
  # see https://forge.puppetlabs.com/puppetlabs/postgresql
  class { 'postgresql::server':
    # This obviously still needs tweaking
    locale                  => 'en_US.UTF-8',
    encoding                => 'UTF8',
    ip_mask_allow_all_users => '0.0.0.0/0',
    listen_addresses        => '*',
    postgres_password       => 'postgres!',
    # see http://www.postgresql.org/docs/8.2/static/auth-pg-hba-conf.html
    ipv4acls                => ['host all talk 192.168.60.1/32 md5'],
    # manage_firewall         => true
  }

  postgresql::server::db { 'talk':
    user     => 'talk',
    password => postgresql_password('talk', 'talk'),
    locale   => 'en_US.UTF-8',
    encoding => 'UTF8',
  }

  # MongoDB
  # see https://forge.puppetlabs.com/puppetlabs/mongodb
  class {'::mongodb::globals':
    manage_package_repo => true,
  }->
  class {'::mongodb::server': }->
  class {'::mongodb::client': }


  # VIM
  class { 'vim':
    ensure => 'present'
  }

  # additional packages
  package { ['pwgen', 'dpkg-dev', 'debhelper', 'libpcre3-dev', 'libxslt-dev', 
    'libgd2-xpm', 'libgd2-xpm-dev', 'libgeoip-dev', 'libpam0g-dev', 
    'libluajit-5.1-dev', 'libperl-dev']:
    ensure => installed;
  }


  # Nginx
  # see https://github.com/hoccer/vagrant-appliance/wiki/Nginx-setup
  file { '/root/nginx-install':
    ensure => directory,
  }

  file { '/root/nginx-install/install.sh':
    source => 'puppet:///modules/talk-production/nginx/install.sh',
    require => File['/root/nginx-install'],
  }

  file { '/root/nginx-install/nginx-1.3.14-no_buffer-v7.patch':
    source => 'puppet:///modules/talk-production/nginx/nginx-1.3.14-no_buffer-v7.patch',
    require => File['/root/nginx-install'],
  }

  file { '/root/nginx-install/nginx_1.4.1-1.debian.tar.gz':
    source => 'puppet:///modules/talk-production/nginx/nginx_1.4.1-1.debian.tar.gz',
    require => File['/root/nginx-install'],
  }

  file { '/root/nginx-install/nginx_1.4.1-1.dsc':
    source => 'puppet:///modules/talk-production/nginx/nginx_1.4.1-1.dsc',
    require => File['/root/nginx-install'],
  }

  file { '/root/nginx-install/nginx_1.4.1.orig.tar.gz':
    source => 'puppet:///modules/talk-production/nginx/nginx_1.4.1.orig.tar.gz',
    require => File['/root/nginx-install'],
  }

  exec { '/root/nginx-install/install.sh':
    require => [File['/root/nginx-install', '/root/nginx-install/install.sh', '/root/nginx-install/nginx-1.3.14-no_buffer-v7.patch', 
      '/root/nginx-install/nginx_1.4.1-1.debian.tar.gz', '/root/nginx-install/nginx_1.4.1-1.dsc', '/root/nginx-install/nginx_1.4.1.orig.tar.gz'],
      Package['dpkg-dev', 'debhelper', 'libpcre3-dev', 'libxslt-dev', 'libgd2-xpm', 'libgd2-xpm-dev', 'libgeoip-dev', 'libpam0g-dev', 
    'libluajit-5.1-dev', 'libperl-dev']],
    path => '/bin:/usr/bin',
  }

  # include helper modules
  include locales
  include postgresql::server
  # include mongodb
  include java7
  include vim

}

