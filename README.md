puppet-talk-production
======================

Puppet module for provisioning production VMs.


Log into server (with SSH agent forwarding):
```
ssh -A deployment@server1.talk.hoccer.de
```

Prepare Puppet modules:
```
mkdir -p ~/puppet/modules
cd ~/puppet/modules
git clone git@github.com:hoccer/puppet-talk-production.git talk-production
gem install librarian-puppet
cd talk-production
librarian-puppet install --path ../
```

Modify ~/puppet/modules/talk-production/config/server1.pp if required.

Run Puppet (leave out '--noop') as user 'root' (bypass system Ruby-1.9.3):
```
sudo -i
cd /home/deployment/puppet
puppet apply --no-report --modulepath modules modules/talk-production/config/server1.pp --verbose --test --noop
exit
```

