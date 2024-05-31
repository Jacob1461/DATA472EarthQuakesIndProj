#!/bin/bash
API_URL="http://localhost:8080/data?limit=5"
RUN_COMMAND_SCRIPT="$(dirname "$0")/run_api.sh"
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
        echo "$(date): Container is less than 5 minutes old. Skipping restart."
        exit 0
    fi
    
    #Check if any container is actually running
    running_container=$(sudo docker ps -q -f ancestor=$IMAGE_NAME)
    if [ -z "$running_container" ]; then
        echo "$(date): No running container found for image $IMAGE_NAME. Starting the Docker container using $RUN_COMMAND_SCRIPT."
        sudo /bin/bash $RUN_COMMAND_SCRIPT
    else
        echo "$(date): Stopping all running Docker containers with image $IMAGE_NAME."
        sudo docker stop $running_container

        echo "$(date): Checking if the Docker image $IMAGE_NAME exists locally."
        if ! sudo docker images -q $IMAGE_NAME > /dev/null; then
            echo "$(date): Docker image $IMAGE_NAME does not exist locally. Pulling from registry."
            sudo docker pull $IMAGE_NAME
        fi

        echo "$(date): Starting the new Docker container using $RUN_COMMAND_SCRIPT."
        sudo /bin/bash $RUN_COMMAND_SCRIPT
    fi
fi
