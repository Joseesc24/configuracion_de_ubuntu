#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Iniciando Purga De Docker"

print_title "01/04 - Removiendo Todos Los Contenedores De Docker"

containers=($(docker ps -aq))
containers_count=${#containers[@]}
print_text "conteo de contenedores: $containers_count"

if (($containers_count > 0)); then

    for container_id in "${containers[@]}"; do

        print_text "removiendo el contenedor $container_id"

        docker rm -f $container_id >/dev/null

    done

else

    print_text "no quedan contenedores por remover"

fi

print_title "02/04 - Removiendo Todas Las Imagenes De Docker"

images=($(docker image ls -q))
images_count=${#images[@]}
print_text "conteo de imágenes: $images_count"

if (($images_count > 0)); then

    for image_id in "${images[@]}"; do

        print_text "removiendo la imagen $image_id"

        docker image rm -f $image_id >/dev/null

    done

else

    print_text "no quedan imágenes por remover"

fi

print_title "03/04 - Removiendo Todos Los Volumenes De Docker"

volumes=($(docker volume ls -q))
volumes_count=${#volumes[@]}
print_text "conteo de volúmenes: $volumes_count"

if (($volumes_count > 0)); then

    for volume_id in "${volumes[@]}"; do

        print_text "removiendo el volumen $volume_id"

        docker volume rm -f $volume_id >/dev/null

    done

else

    print_text "no quedan volúmenes por remover"

fi

print_title "04/04 - Removiendo Todas Las Redes De Docker"

docker network prune -f

print_title "Purga De Docker Finalizada"
