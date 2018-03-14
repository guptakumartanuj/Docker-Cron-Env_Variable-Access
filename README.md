# Docker-Cron-Env_Variable-Access
This shows how to access the environment variable in a script file while running the cron job inside docker

Below is the list of commands to create a docker container using the crontab -

To build the docker image -

$ docker build -t cron-job .

To run the docker image -

$ docker run -it --name cron-job cron-job

In the interval of 1 minute, you will see the below output on the terminal and same would ve saved in the given path log file.

First Cron Job First Cron Job . . In addition to it, It will sync the remote azure blog directory with the local directory path in every 2 minutes.

## Using environment variables

Here the goal is to read the environment variable inside the script file. If we don't inject the env variable using the below approach, we won't be able to access the env variable. 

With out injecting the env variable, if we do echo $ENV_DAG_NAME inside the script, then it will give us the output as empty Srting. If we do the echo on the command prompt, then it will give us the right output.

// THe below line shows how to grep environment variable aur use them in the script. In this, first I have greped the env variable (ENV_DAG_CONTAINER) and then moved this variable into the temp file. Finally added this at the top of the script so that we can use it.

```
env | egrep '^ENV_DAG' | cat - /dag_script.sh > temp && mv temp /dag_script.sh
```

Add env variable to the docker run command using the below command or set them inside the Docker file (shown in the Dockerfile) if you don't need to change them at run time.

```
$ docker run -it -e ENV_DAG_CONTAINER=tanuj docker-cron-example
```


## The Dockerfile

```
FROM ubuntu:16.04

RUN apt-get update && apt install -y build-essential libmysqlclient-dev python-dev libapr1-dev libsvn-dev wget libcurl4-nss-dev libsasl2-dev libsasl2-modules zlib1g-dev curl cron zip  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends rsync && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

// Either Hardcode the environment variable here or pass these through docker run command using -e flag (ex. "-e ENV_DAG_CONTAINER=test")
ENV ENV_DAG_CONTAINER=test

COPY crontab /usr/tanuj/crontab

COPY run-crond.sh /run-crond.sh

RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && unzip rclone-current-linux-amd64.zip

WORKDIR rclone-v1.39-linux-amd64

RUN chmod 755 /usr/tanuj/ && chmod 755 /run-crond.sh && mkdir -p /var/log/cron && touch /var/log/cron/cron.log && mkdir -p /tmp/azure/local && mkdir -p /tmp/azure/dag && mkdir -p /tmp/azure/plugin  && mkdir -p /root/.config/rclone && cp rclone /usr/bin/ && chown root:root /usr/bin/rclone && chmod 755 /usr/bin/rclone && chmod 755 /root/.config/rclone

COPY rclone.conf /root/.config/rclone/
// COPY and AND commands are equivalent.
ADD script.sh /script.sh

COPY dag_script.sh /dag_script.sh

RUN chmod +x /dag_script.sh && chmod +x /script.sh && touch /var/log/cron.log

CMD ["/run-crond.sh"]



```

1. In the first step, I have used FROM command to specify the base image through which we need to run inside the container.
2. Then, I have installed all the required dependencies using RUN command (use apt-get install, apt add install , yum install etc based on your supported distribution in the base image)
3. ENV command is used to set the environment variable required inside the container.
4. Next, COPY command is used to copy the crontab file to the /usr/tanuj directory of the container in order to make it available inside run-crond.sh file and then copied the crontab run script to the container to make it executable.
5. I Created desired directories and log files required to run the cron job and then gave them the required permission as well.
5. Copied the desired script file which is used inside the cron job to run and again gave it the required permission.
5. Finally, I specified the CMD command which will be executed once the container is started running.

## Copyright 

Copyright (c) 2018 Tanuj Gupta

---

> GitHub [@guptakumartanuj](https://github.com/guptakumartanuj) &nbsp;&middot;&nbsp;
> [Blog](https://guptakumartanuj.wordpress.com/) &nbsp;&middot;&nbsp;
