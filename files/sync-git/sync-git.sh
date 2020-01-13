#!/bin/bash

(
  while true; do
    sudo -u coderdojo git -C /var/lib/coderdojo/projects pull
    sleep 10
  done
) &

while true; do
  inotifywait -r -e modify,attrib,close_write,move,create,delete /var/lib/coderdojo/projects
  sudo -u coderdojo git -C /var/lib/coderdojo/projects add -A .
  sudo -u coderdojo git -C /var/lib/coderdojo/projects commit -m "Autocommit from $HOSTNAME"
  GIT_SSH_COMMAND='ssh -i /var/lib/coderdojo/projects/.repokey' git -C /var/lib/coderdojo/projects push
done
