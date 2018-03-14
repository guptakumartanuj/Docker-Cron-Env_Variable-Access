FROM ubuntu:16.04

MAINTAINER "Tanuj Gupta"

RUN apt-get update && apt install -y build-essential libmysqlclient-dev python-dev libapr1-dev libsvn-dev wget libcurl4-nss-dev libsasl2-dev libsasl2-modules zlib1g-dev curl cron zip  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends rsync && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

// Either Hardcode the environment variable here or pass these through docker run command using -e flag (ex. "-e ENV_DAG_CONTAINER=test")
ENV ENV_DAG_CONTAINER=test

COPY crontab /tmp/crontab

COPY run-crond.sh /run-crond.sh

RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && unzip rclone-current-linux-amd64.zip

WORKDIR rclone-v1.39-linux-amd64

RUN chmod 755 /tmp/crontab && chmod 755 /run-crond.sh && mkdir -p /var/log/cron && touch /var/log/cron/cron.log && mkdir -p /tmp/azure/local && mkdir -p /tmp/azure/dag && mkdir -p /tmp/azure/plugin  && mkdir -p /root/.config/rclone && cp rclone /usr/bin/ && chown root:root /usr/bin/rclone && chmod 755 /usr/bin/rclone && chmod 755 /root/.config/rclone

COPY rclone.conf /root/.config/rclone/
// COPY and AND commands are equivalent.
COPY script.sh /script.sh

ADD dag_script.sh /dag_script.sh

RUN chmod +x /dag_script.sh && chmod +x /script.sh && touch /var/log/cron.log

CMD ["/run-crond.sh"]
