class talk-production::config {
  
  class { 'locales':
    locales => ['en_US.UTF-8 UTF-8']
  }

  include locales


  # service user for talkserver & filecache
  user { 'talk':
    ensure     => present,
    groups     => [],
    managehome => true,
    shell      => '/bin/bash',
  }

  # service user for riemann metrics
  user { 'riemann':
    ensure     => present,
    groups     => [],
    managehome => true,
    shell      => '/bin/bash',
  }

  # add users to RVM group
  rvm::system_user { 'deployment': ; 'riemann': ; }


  # Nginx configuration
  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/nginx/nginx.conf',
    require => Exec['/root/nginx-install/install.sh'],
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
    require => Exec['/root/nginx-install/install.sh'],
    notify  => Service['nginx'],
  }

  file { "/etc/default/nginx" :
    ensure  => present,
    source  => 'puppet:///modules/talk-production/nginx/defaults',
    require => Exec['/root/nginx-install/install.sh'],
    notify  => Service['nginx'],
  }

  file { '/etc/ssl/certs/filecache-cert.pem':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/ssl/filecache-cert.pem',
    require => Exec['/root/nginx-install/install.sh'],
    notify  => Service['nginx'],
  }

  file { '/etc/ssl/private/filecache-key.pem':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/ssl/filecache-key.pem',
    require => Exec['/root/nginx-install/install.sh'],
    notify  => Service['nginx'],
  }

  file { '/etc/ssl/certs/server-cert.pem':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/ssl/server-cert.pem',
    require => Exec['/root/nginx-install/install.sh'],
    notify  => Service['nginx'],
  }

  file { '/etc/ssl/private/server-key.pem':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/ssl/server-key.pem',
    require => Exec['/root/nginx-install/install.sh'],
    notify  => Service['nginx'],
  }

  service { 'nginx':
    ensure => running,
  }


  # talkserver configuration
  file { '/etc/init/talkserver.conf':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/talkserver/talkserver.conf',
  }

  file { '/etc/sysctl.d/60-talkserver.conf':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/talkserver/sysctl.conf',
  }

  # filecache configuration
  file { '/etc/init/filecache.conf':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/filecache/filecache.conf',
  }


  # filecache restart script
  file { '/root/restart_filecache.sh':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///modules/talk-production/filecache/restart_filecache.sh',
  }

  file { 'restart_filecache':
    path    => '/etc/cron.d/restart_filecache',
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => File['/root/restart_filecache.sh'],
    content => "* * * * * root /root/restart_filecache.sh\n";
  }


  # backup scripts
  file { '/etc/cron.daily/postgres':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///modules/talk-production/cron/postgres',
  }

  file { '/etc/cron.daily/mongodb':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///modules/talk-production/cron/mongodb',
  }

}