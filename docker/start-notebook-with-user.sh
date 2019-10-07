#!/usr/bin/env bash

HOME=/home/zoo_user

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    mkdir $HOME
    echo "${USER_NAME:-zoo_user}:x:$(id -u):0:${USER_NAME:-zoo_user} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

/opt/work/start-notebook.sh