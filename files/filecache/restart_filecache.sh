#!/bin/bash

# check if upstart job was started
service filecache status | grep start >/dev/null

if [ "$?" -eq "0" ]; then
  echo "filecache upstart job is running."
  curl -k -s -f -m 5 https://filecache1.talk.hoccer.de/status >/dev/null
  ret=$?
  if [ "$ret" -ne "0" ]; then
    echo "filecache service seems to hang. Restarting."
    service filecache restart
    echo "Filecache service has been restarted. Return value of curl was $ret. See curl manpage." | mail -s "Hoccer: Filecache service has been restarted." admins@hoccer.com
  else
    echo "filecache service seems to run fine."
  fi

else
  echo "filecache upstart job is stopped."
fi

