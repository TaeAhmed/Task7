#!/bin/bash

# Function to display the menu
function display_menu {
  echo ""
  echo "Docker Management (user mode)"
  echo "1. List all containers"
  echo "2. List all running containers"
  echo "3. List all images"
  echo "4. Run container (detached)"
  echo "5. Stop a container"
  echo "6. Remove a container"
  echo "7. Remove an image"
  echo "8. Remove all unused images"
  echo "9. Remove all stopped containers"
  echo "10. Remove all containers"
  echo "11. Remove all images"
  echo "12. Pull image"
  echo "13. Exit"
  echo ""
  echo -n "Enter your choice (1-13): "
}

# Main loop for user interaction
while true; do
  display_menu
  read choice

  case $choice in
    1)
      docker ps -a
      ;;
    2)
      docker ps
      ;;
    3)
      docker images
      ;;
    4)
      echo "Enter image name or hash(id) or digest:"
      read image
      # Validate image existence
      if ! docker image inspect $image >/dev/null 2>&1; then
        echo "Error: Invalid or Image does not exist locally."
        continue
      fi

      echo "Enter tag (optional):"
      read tag
      echo "Enter container name (optional):"
      read name
      echo "Enter ports (format: host_port:container_port) (optional):"
      read ports

      # Build the docker run command with optional arguments
      docker_cmd="docker run -d"
      if [[ ! -z "$name" ]]; then
        docker_cmd="$docker_cmd --name $name"
      fi
      if [[ ! -z "$ports" ]]; then
        docker_cmd="$docker_cmd -p $ports"
      fi
      if [[ ! -z "$tag" ]]; then
        docker_cmd="$docker_cmd $image:$tag"
      fi
      docker_cmd="$docker_cmd $image"

      # Execute the docker run command
      $docker_cmd
      ;;
    5)
      echo "Enter container name or hash(id) to stop:"
      read container
      docker stop $container
      ;;
    6)
      echo "Enter container name or hash(id) to remove:"
      read container
      # Check if container is running
      if docker ps -q -f name="$container" >/dev/null 2>&1; then
        echo "Warning: Container is running. Stopping it first is recommended."
        continue
      fi
      docker rm $container
      ;;
    7)
      echo "Enter image name or hash(id) to remove:"
      read image
      docker rmi $image
      ;;
    8)
      docker image prune -f -a
      ;;
    9)
      docker rm $(docker ps -a -q -f status=exited)
      ;;
    10)
      docker rm $(docker ps -a -q)
      ;;
    11)
      docker rmi $(docker images -q)
      ;;
    12)
      echo "Enter image name to pull:"
      read image
      docker pull $image
      ;;
    13)
      echo "Exiting..."
      break
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done

echo "Docker Management finished."
