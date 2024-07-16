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
      echo "Enter image name:"
      read image
      echo "Enter tag (optional):"
      read tag
      if [[ -z "$tag" ]]; then
        tag="latest"
      fi
      echo "Enter container name:"
      read name
      echo "Enter ports (format: host_port:container_port):"
      read ports
      docker run -d --name $name -p $ports $image:$tag
      ;;
    5)
      echo "Enter container name to stop:"
      read name
      docker stop $name
      ;;
    6)
      echo "Enter container name to remove:"
      read name
      docker rm $name
      ;;
    7)
      echo "Enter image name to remove:"
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
