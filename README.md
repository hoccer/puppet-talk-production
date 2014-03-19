puppet-talk-production
======================

Puppet module for provisioning production VMs.


prepare Puppet modules:
```
cd puppet/modules
git clone https://github.com/hoccer/puppet-talk-production.git talk-production
gem install librarian-puppet
cd talk-production
librarian-puppet install --path ../
```

create puppet/server.pp manifest:
```
include talk-production
```
