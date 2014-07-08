class talk-production::install {

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
  class {'::mongodb::server': }


  # VIM
  class { 'vim':
    ensure => 'present'
  }

  # additional packages
  package { ['pwgen', 'dpkg-dev', 'debhelper', 'libpcre3-dev', 'libxslt1-dev',
    'libgd2-noxpm-dev', 'libgeoip-dev', 'libpam0g-dev',
    'libluajit-5.1-dev', 'libperl-dev', 'autotools-dev', 'liblua5.1-0-dev',
    'libmhash-dev', 'libssl-dev', 'libexpat1-dev']:
    ensure => installed;
  }


  # Nginx
  # see https://github.com/hoccer/vagrant-appliance/wiki/Nginx-setup
  file { '/root/nginx-install':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { '/root/nginx-install/install.sh':
    source  => 'puppet:///modules/talk-production/nginx/install.sh',
    owner   => 'root',
    group   => 'root',
    require => File['/root/nginx-install'],
  }

  file { '/root/nginx-install/nginx-1.3.14-no_buffer-v7.patch':
    source => 'puppet:///modules/talk-production/nginx/nginx-1.3.14-no_buffer-v7.patch',
    owner   => 'root',
    group   => 'root',
    require => File['/root/nginx-install'],
  }

  file { '/root/nginx-install/nginx_1.4.1-1.debian.tar.gz':
    source => 'puppet:///modules/talk-production/nginx/nginx_1.4.1-1.debian.tar.gz',
    owner   => 'root',
    group   => 'root',
    require => File['/root/nginx-install'],
  }

  file { '/root/nginx-install/nginx_1.4.1-1.dsc':
    source => 'puppet:///modules/talk-production/nginx/nginx_1.4.1-1.dsc',
    owner   => 'root',
    group   => 'root',
    require => File['/root/nginx-install'],
  }

  file { '/root/nginx-install/nginx_1.4.1.orig.tar.gz':
    source => 'puppet:///modules/talk-production/nginx/nginx_1.4.1.orig.tar.gz',
    owner   => 'root',
    group   => 'root',
    require => File['/root/nginx-install'],
  }

  exec { '/root/nginx-install/install.sh':
    require => [File['/root/nginx-install', '/root/nginx-install/install.sh', '/root/nginx-install/nginx-1.3.14-no_buffer-v7.patch',
      '/root/nginx-install/nginx_1.4.1-1.debian.tar.gz', '/root/nginx-install/nginx_1.4.1-1.dsc', '/root/nginx-install/nginx_1.4.1.orig.tar.gz'],
      Package['dpkg-dev', 'debhelper', 'libpcre3-dev', 'libxslt1-dev', 'libgd2-noxpm-dev', 'libgeoip-dev', 'libpam0g-dev',
    'libluajit-5.1-dev', 'libperl-dev', 'autotools-dev', 'liblua5.1-0-dev', 'libmhash-dev', 'libssl-dev', 'libexpat1-dev']],
    path => '/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
    creates => "/root/nginx-install/nginx-full_1.4.1-1_amd64.deb",
    timeout => 1800,
  }


  # NTP
  class { '::ntp':
    servers => [ 'pool.ntp.org' ],
  }

  include rvm

  rvm_system_ruby {
    'ruby-2.0.0-p353':
      ensure => 'present',
  }

  # riemann-net & riemann-health
  class { 'riemann::tools':
    host            => 'monitoring-server.hoccer.de',
    rvm_ruby_string => 'ruby-2.0.0-p353',
    require => Rvm_system_ruby['ruby-2.0.0-p353'],
  }


  # include helper modules
  include postgresql::server
  include java
  include vim
  include ntp
}
