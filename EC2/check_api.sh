#!/bin/bash
API_URL="http://localhost:8080/data?limit=5"
RUN_COMMAND_SCRIPT="runcommand.sh"
IMAGE_NAME="earthquakesapi"

container_age() {
    local container_id=$(sudo docker ps -q -f ancestor=$IMAGE_NAME)
    if [ -z "$container_id" ]; then
        echo 9999
        return
    fi
    local start_time=$(sudo docker inspect -f '{{.State.StartedAt}}' $container_id)
    local start_timestamp=$(date -d "$start_time" +%s)
    local current_timestamp=$(date +%s)
    local age=$((current_timestamp - start_timestamp))
    echo $age
}
response=$(curl -o /dev/null -s -w "%{http_code}" $API_URL)

if [ $response -eq 200 ]; then
    echo "$(date): API is running with status code 200."
else
    echo "$(date): API is not responding correctly. Status code: $response."
    age=$(container_age)
    if [ $age -lt 300 ]; then
        echo "$(date): Container is less than 5 minutes old. Skipping restart." #Takes a hot min to start up the api container so skip new containers
        exit 0
    fi
    echo "$(date): Stopping all running Docker containers with image $IMAGE_NAME."
    sudo docker stop $(sudo docker ps -q -f ancestor=$IMAGE_NAME)

    echo "$(date): Starting the new Docker container using runcommand.sh."
    sudo /bin/bash $RUN_COMMAND_SCRIPT
fi
