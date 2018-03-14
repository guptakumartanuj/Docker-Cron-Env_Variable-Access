#!/bin/sh
#crontab crontab
crontab  /tmp/crontab
// THe below line shows how to grep environment variable aur use them in the script. In this, first I have greped the env variable (ENV_DAG_CONTAINER) and then moved this variable into the temp file. Finally added this at the top of the script so that we can use it.
env | egrep '^ENV_DAG' | cat - /dag_script.sh > temp && mv temp /dag_script.sh

// To start the cron service inside the container
service cron start