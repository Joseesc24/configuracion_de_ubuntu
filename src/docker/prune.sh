#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Starting Docker Prune"

print_title "01/05 - Removing All Docker Containers"

containers=($(docker ps -aq))
containers_count=${#containers[@]}
print_text "containers count: $containers_count"

if (($containers_count > 0)); then
	for container_id in "${containers[@]}"; do
		print_text "removing container $container_id"
		docker rm -f $container_id > /dev/null
	done
else
	print_text "no containers left to remove"
fi

print_title "02/05 - Removing All Docker Images"

images=($(docker image ls -q))
images_count=${#images[@]}
print_text "images count: $images_count"

if (($images_count > 0)); then
	for image_id in "${images[@]}"; do
		print_text "removing image $image_id"
		docker image rm -f $image_id > /dev/null
	done
else
	print_text "no images left to remove"
fi

print_title "03/05 - Removing All Docker Volumes"

volumes=($(docker volume ls -q))
volumes_count=${#volumes[@]}
print_text "volumes count: $volumes_count"

if (($volumes_count > 0)); then
	for volume_id in "${volumes[@]}"; do
		print_text "removing volume $volume_id"
		docker volume rm -f $volume_id > /dev/null
	done
else
	print_text "no volumes left to remove"
fi

print_title "04/05 - Removing All Docker Networks"

docker network prune -f

print_title "05/05 - Removing Docker Residual Files"

docker system prune -f

print_title "Docker Prune Finished"
