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
  primary_talkserver_fqdn      => 'test1.talk.hoccer.de',
  primary_talkserver_port      => 8443,
  primary_talkserver_cert      => '/etc/ssl/certs/talkserver.talk.hoccer.de.crt',
  primary_talkserver_key       => '/etc/ssl/private/talkserver.talk.hoccer.de.key',
  primary_talkserver_backend   => 'talkserver_backend',
  secondary_talkserver_fqdn    => 'test1.talk.hoccer.de',
  secondary_talkserver_port    => 443,
  secondary_talkserver_cert    => '/etc/ssl/certs/talkserver.talk.hoccer.de.crt',
  secondary_talkserver_key     => '/etc/ssl/private/talkserver.talk.hoccer.de.key',
  secondary_talkserver_backend => 'talkserver_backend',
  filecache_fqdn               => 'filecache-test1.talk.hoccer.de',
  filecache_port               => 8444,
  filecache_cert               => '/etc/ssl/certs/filecache.talk.hoccer.de.crt',
  filecache_key                => '/etc/ssl/private/filecache.talk.hoccer.de.key',
  invitation_server_fqdn       => 'invite-test1.hoccer.com',
  invitation_server_port       => 443,
  invitation_server_cert       => '/etc/ssl/certs/hoccer.com.chained.crt',
  invitation_server_key        => '/etc/ssl/private/hoccer.com.key',
  invitation_uri_scheme        => 'hcrd',
}

include backuppc-client
include deployment-user
include nrpe
include admin-user
include talk-production

