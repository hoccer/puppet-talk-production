#!/bin/bash

# check if upstart job was started
/sbin/status filecache | /bin/grep running >/dev/null

if [ "$?" -eq "0" ]; then
  /usr/bin/curl -k -s -f -m 10 https://filecache1.talk.hoccer.de/status >/dev/null
  ret=$?
  if [ "$ret" -ne "0" ]; then
    echo "filecache service seems to hang. Restarting."
    /sbin/restart filecache
    echo "Filecache service has been restarted. Return value of curl was $ret. See curl manpage." | mail -s "Hoccer: Filecache service has been restarted." admins@hoccer.com
  fi
fi
