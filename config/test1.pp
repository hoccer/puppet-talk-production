define line($file, $line, $ensure = 'present') {
    case $ensure {
        default : { err ( "unknown ensure value ${ensure}" ) }
        present: {
            exec { "/bin/echo '${line}' >> '${file}'":
                unless => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
        absent: {
            exec { "/bin/grep -vFx '${line}' '${file}' | /usr/bin/tee '${file}' > /dev/null 2>&1":
              onlyif => "/bin/grep -qFx '${line}' '${file}'"
            }

            # Use this resource instead if your platform's grep doesn't support -vFx;
            # note that this command has been known to have problems with lines containing quotes.
            # exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
            #     onlyif => "/bin/grep -qFx '${line}' '${file}'"
            # }
        }
    }
}


class { 'talk-production':
  talkserver_fqdn        => 'test1.talk.hoccer.de',
  talkserver_port        => 8443,
  talkserver_cert        => '/etc/ssl/certs/talkserver.talk.hoccer.de.crt',
  talkserver_key         => '/etc/ssl/private/talkserver.talk.hoccer.de.key',
  legacy_talkserver_fqdn => 'server.talk.hoccer.de',
  legacy_talkserver_port => 443,
  legacy_talkserver_cert => '/etc/ssl/certs/server-cert.pem',
  legacy_talkserver_key  => '/etc/ssl/private/server-key.pem',
  filecache_fqdn         => 'filecache-test1.talk.hoccer.de',
  filecache_port         => 8444,
  filecache_cert         => '/etc/ssl/certs/filecache.talk.hoccer.de.crt',
  filecache_key          => '/etc/ssl/private/filecache.talk.hoccer.de.key',
  legacy_filecache_fqdn  => 'filecache.talk.hoccer.de',
  legacy_filecache_port  => 443,
  legacy_filecache_cert  => '/etc/ssl/certs/filecache-cert.pem',
  legacy_filecache_key   => '/etc/ssl/private/filecache-key.pem',
}

include backuppc-client
include deployment-user
include nrpe
include admin-user
include talk-production

