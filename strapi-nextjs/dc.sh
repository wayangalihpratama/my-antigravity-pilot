#!/bin/bash

# dc.sh - Docker Compose Wrapper

case "$1" in
  up)
    docker compose up "${@:2}"
    ;;
  down)
    docker compose down "${@:2}"
    ;;
  exec)
    if [ "$2" == "backend" ]; then
      docker compose exec backend "${@:3}"
    elif [ "$2" == "frontend" ]; then
      docker compose exec frontend "${@:3}"
    else
      echo "Usage: ./dc.sh exec [backend|frontend] [command]"
    fi
    ;;
  ps)
    docker compose ps
    ;;
  logs)
    docker compose logs "${@:2}"
    ;;
  *)
    echo "Usage: ./dc.sh {up|down|exec|ps|logs}"
    exit 1
    ;;
esac
