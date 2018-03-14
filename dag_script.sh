// This below line will be appeneded through the run-scrond.sh file once the container is started. I have used it here for the testing purpose. 
ENV_DAG_CONTAINER=test
echo "$(date): executed script" >> /var/log/cron.log 2>&1
if [ -n "$ENV_DAG_CONTAINER" ]
then
    echo "rclone process is started"
    while true; do
	  rclone sync -v remote:$ENV_DAG_CONTAINER /tmp/azure/local/dags && rsync -avc /tmp/azure/local/dags/* /usr/local/airflow/dags & sleep 5;
     done
     echo "rclone and rsync process is ended"
fi
