class talk-production::config {
  
  class { 'locales':
    locales => ['en_US.UTF-8 UTF-8']
  }

  include locales

  # setup service user
  user { 'talk':
    ensure     => present,
    groups     => [],
    managehome => true,
    shell      => '/bin/bash',
  }
  
  # Nginx configuration
  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    source  => 'puppet:///modules/talk-production/nginx/nginx.conf',
    require => Exec['/root/nginx-install/install.sh'],
    notify  => Service['nginx'],
  }

  augeas{ "nginx-defaults" :
    context => "/etc/default/nginx",
    changes => "set ULIMIT '-n 202000'",
    onlyif  => "match other_value size > 0",
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

}