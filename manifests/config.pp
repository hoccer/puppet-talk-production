class talk-production::config {
  
  class { 'locales':
    default_locale => 'en_US.UTF-8',
    locales        => ['en_US.UTF-8 UTF-8'],
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
    owner   => 'root',
    group   => 'root',
    content => template('talk-production/nginx/nginx.conf.erb'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure  => absent,
    owner   => 'root',
    group   => 'root',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { "/etc/default/nginx" :
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/talk-production/nginx/defaults',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  service { 'nginx':
    ensure => running,
  }


  # talkserver configuration
  file { '/etc/init/talkserver.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/talk-production/talkserver/talkserver.conf',
  }

  file { '/etc/sysctl.d/60-talkserver.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/talk-production/talkserver/sysctl.conf',
  }

  # filecache configuration
  file { '/etc/init/filecache.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/talk-production/filecache/filecache.conf',
  }


  # talkserver restart script
  file { '/root/restart_talkserver.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('talk-production/talkserver/restart_talkserver.sh.erb'),
  }

  file { 'restart_talkserver':
    path    => '/etc/cron.d/restart_talkserver',
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => File['/root/restart_talkserver.sh'],
    content => "* * * * * root /root/restart_talkserver.sh\n";
  }


  # filecache restart script
  file { '/root/restart_filecache.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('talk-production/filecache/restart_filecache.sh.erb'),
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
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/talk-production/cron/postgres',
  }

  file { '/etc/cron.daily/mongodb':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/talk-production/cron/mongodb',
  }


  # log rotation
  file { '/etc/logrotate.d/talkserver':
    ensure => absent,
  }

  file { '/etc/logrotate.d/filecache':
    ensure => absent,
  }


}