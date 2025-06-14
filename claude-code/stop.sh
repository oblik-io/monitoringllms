#!/bin/bash

# Stop Claude Code Monitoring Stack

echo "🛑 Stopping Claude Code monitoring stack..."

if docker compose version &> /dev/null; then
    docker compose down
else
    docker-compose down
fi

echo "✅ Monitoring stack stopped"