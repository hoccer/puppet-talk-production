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
    ensure => present,
    source => 'puppet:///modules/talk-production/nginx/nginx.conf',
    require => Exec['/root/nginx-install/install.sh'],
  }
}