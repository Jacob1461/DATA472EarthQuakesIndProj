LOG_FILE="earthquakesapi.log"

sudo docker run --env-file .env -p 8080:8080 earthquakesapi > $LOG_FILE 2>&1 &

echo "Docker container is running in the background. Logs are being saved to $LOG_FILE"