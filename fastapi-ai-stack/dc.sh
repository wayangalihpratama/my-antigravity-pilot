#!/bin/bash

# Wrapper for docker compose commands to ensure consistency

usage() {
    echo "Usage: ./dc.sh [command]"
    echo "Commands:"
    echo "  up       Start the services"
    echo "  down     Stop the services"
    echo "  logs     View logs"
    echo "  exec     Execute a command in a running container"
    echo "  ps       List running containers"
    echo "  build    Build the services"
    echo "  tests    Run backend tests"
    echo ""
    echo "Example:"
    echo "  ./dc.sh up -d"
    echo "  ./dc.sh exec app bash"
}

if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    DOCKER_COMPOSE="docker compose"
fi

if [ "$1" == "tests" ]; then
    shift
    $DOCKER_COMPOSE exec app pytest "$@"
else
    $DOCKER_COMPOSE "$@"
fi
