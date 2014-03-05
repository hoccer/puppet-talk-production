class talk-production::config {
  
  class { 'locales':
    locales => ['en_US.UTF-8 UTF-8']
  }

  # setup required users
  user { 'deployment':
    ensure     => present,
    groups     => ['adm','admin', 'sudo'],
    managehome => true,
    shell      => '/bin/bash',
  }
  user { 'talk':
    ensure     => present,
    groups     => [],
    managehome => true,
    shell      => '/bin/bash',
  }
  
}