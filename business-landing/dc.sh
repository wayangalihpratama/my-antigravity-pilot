#!/bin/bash
set -euo pipefail

# Wrapper for docker compose commands in business-landing
usage() {
    echo "Usage: ./dc.sh [command]"
    echo "Commands:"
    echo "  up       Start local preview server (http://localhost:8080)"
    echo "  down     Stop the services"
    echo "  logs     View logs"
    echo "  exec     Execute command in container"
    echo "  ps       List running containers"
}

if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    DOCKER_COMPOSE="docker compose"
fi

$DOCKER_COMPOSE "$@"
