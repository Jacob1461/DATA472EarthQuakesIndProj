LOG_DIR="/home/ubuntu/logs"
LOG_FILE_PATTERN="$LOG_DIR/logfile-$(date +'%Y-%m-%d').log"

run_container() {
  sudo docker run -d --env-file .env -p 8080:8080 earthquakesupdater > $LOG_FILE_PATTERN 2>&1
}

while true; do
  sudo docker stop earthquake_updater
  sudo docker rm earthquake_updater
  run_container

  find $LOG_DIR -name 'logfile-*.log' -mtime +7 -exec rm {} \; #Delete logs older than a week


  sleep 86400 # wait 24 hrs
done
