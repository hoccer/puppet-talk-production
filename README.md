puppet-talk-production
======================

Puppet module for provisioning production VMs. Use this module by including the 'talk-production' class in a puppet provisioning like this.

```
class { 'talk-production':
  primary_talkserver_fqdn      => 'talkserver.talk.hoccer.de',
  primary_talkserver_port      => 8443,
  primary_talkserver_cert      => '/etc/ssl/certs/talkserver.talk.hoccer.de.crt',
  primary_talkserver_key       => '/etc/ssl/private/talkserver.talk.hoccer.de.key',
  primary_talkserver_backend   => 'talkserver_backend',
  secondary_talkserver_fqdn    => 'talkserver.talk.hoccer.de',
  secondary_talkserver_port    => 443,
  secondary_talkserver_cert    => '/etc/ssl/certs/talkserver.talk.hoccer.de.crt',
  secondary_talkserver_key     => '/etc/ssl/private/talkserver.talk.hoccer.de.key',
  secondary_talkserver_backend => 'review_talkserver_backend',
  filecache_fqdn               => 'filecache.talk.hoccer.de',
  filecache_port               => 8444,
  filecache_cert               => '/etc/ssl/certs/filecache.talk.hoccer.de.crt',
  filecache_key                => '/etc/ssl/private/filecache.talk.hoccer.de.key',
}
```
The secondary talkserver is optional and can be used to install a second _talkserver_ instance e.g. for the client review process.