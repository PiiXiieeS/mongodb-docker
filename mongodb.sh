#!/bin/bash

# Rsyslog setup
if [ ! -z "$RSYSLOG" ]
then
  echo "Adding RSYSLOGD configuration"
  
  echo "$RSYSLOG" >> /etc/rsyslog.conf
fi

# Setup mongodb user
# $1 'setup' to do setup
# $2 the database to set up .. e.g. 'admin'
# Note, pass in a volume with /tmp/setup.js file.

if [ "$1" == "setup" ]
then
  echo "Performing Initial Setup"
  
  mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --noauth &
  mongod_pid=$!
  
  echo "Sleeping 5 secs for mongodb to become available... "
  sleep 5
  
  mongo "$2" /tmp/setup.js
  
  kill $mongod_pid
  exit 0
fi

mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --auth
