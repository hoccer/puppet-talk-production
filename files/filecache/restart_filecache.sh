#!/bin/bash

# check if upstart job was started
service filecache status | grep start >/dev/null

if [ "$?" -eq "0" ]; then
  echo "filecache upstart job is running."
  curl -k -s https://filecache1.talk.hoccer.de/status >/dev/null

  if [ "$?" -ne "0" ]; then
    echo "filecache service seems to hang. Restarting."
    service filecache restart
  else
    echo "filecache service seems to run fine."
  fi

else
  echo "filecache upstart job is stopped."
fi

