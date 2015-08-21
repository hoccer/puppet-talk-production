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
  file { '/etc/apt/sources.list.d/nginx.list':
    owner   => 'root',
    group   => 'root',
    content => 'deb http://nginx.org/packages/mainline/ubuntu/ precise nginx
',
    notify  => Exec['add_nginx_key'],
  }

  exec { 'curl http://nginx.org/keys/nginx_signing.key | apt-key add -':
    path        => '/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
    refreshonly => true,
    alias       => 'add_nginx_key',
    notify      => Exec['aptitude_update'],
  }

  exec { 'aptitude update':
    path        => '/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
    refreshonly => true,
    alias       => 'aptitude_update',
  }

  package { 'nginx':
    ensure  => latest,
    require => File['/etc/apt/sources.list.d/nginx.list']
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
