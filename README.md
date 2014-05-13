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
  talkserver_fqdn => server.hoccer.de,
  talkserver_cert => /etc/ssl/certs/talkserver.cert, 
  talkserver_key => /etc/ssl/private/talkserver.key,
  filecache_fqdn  => filecache.hoccer.de,
  filecache_cert  => /etc/ssl/certs/filecache.cert,
  filecache_key  => /etc/ssl/private/filecache.cert,
}
```
