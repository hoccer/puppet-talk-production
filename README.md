puppet-talk-production
======================

Puppet module for provisioning production VMs.


Prepare Puppet modules:
```
cd puppet/modules
git clone https://github.com/hoccer/puppet-talk-production.git talk-production
gem install librarian-puppet
cd talk-production
librarian-puppet install --path ../
```

Create puppet/server.pp manifest including this module with parameter:
```
class { 'talk-production':
  talkserver_fqdn => talkserver.talk.hoccer.de,
  talkserver_cert => /etc/ssl/certs/talkserver.crt,
  talkserver_key => /etc/ssl/private/talkserver.key,
  legacy_talkserver_fqdn => server.talk.hoccer.de,
  legacy_talkserver_cert => /etc/ssl/certs/legacy_talkserver.crt,
  legacy_talkserver_key => /etc/ssl/private/legacy_talkserver.key,
  filecache_fqdn  => filecache.talk.hoccer.de,
  filecache_cert  => /etc/ssl/certs/filecache.crt,
  filecache_key  => /etc/ssl/private/filecache.key,
  legacy_filecache_fqdn  => filecache.talk.hoccer.de,
  legacy_filecache_cert  => /etc/ssl/certs/legacy_filecache.crt,
  legacy_filecache_key  => /etc/ssl/private/legacy_filecache.key,
}
```
