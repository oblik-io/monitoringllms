#!/bin/bash

# Setup script for [Provider Name] Monitoring
# Replace [provider-name] with actual provider name

set -e

PROVIDER_NAME="[provider-name]"
PROVIDER_UPPER="[PROVIDER]"

echo "🚀 Setting up $PROVIDER_NAME monitoring for BMAD..."

# Check prerequisites
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Set up environment variables
echo "📝 Setting up environment variables..."
export ${PROVIDER_UPPER}_ENABLE_TELEMETRY=1
export ${PROVIDER_UPPER}_METRICS_PORT=9464

# Display current configuration
echo ""
echo "Current configuration:"
echo "  Provider: $PROVIDER_NAME"
echo "  Metrics Port: 9464"
echo "  Telemetry: Enabled"
echo ""

# Start the monitoring stack
echo "🐳 Starting Docker containers..."
docker compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Check service health
echo "🔍 Checking service status..."
if curl -s http://localhost:9090 > /dev/null; then
    echo "✅ Prometheus is running"
else
    echo "❌ Prometheus is not accessible"
fi

if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Grafana is running"
else
    echo "❌ Grafana is not accessible"
fi

# Display access information
echo ""
echo "✨ Monitoring stack is ready!"
echo ""
echo "📊 Access your dashboards:"
echo "  Prometheus: http://localhost:9090"
echo "  Grafana: http://localhost:3000 (admin/admin)"
echo ""
echo "🔧 To enable metrics in your terminal session:"
echo "  export ${PROVIDER_UPPER}_ENABLE_TELEMETRY=1"
echo "  export ${PROVIDER_UPPER}_METRICS_PORT=9464"
echo ""
echo "📝 For persistent configuration, add these to your shell profile or"
echo "   update your provider's settings file."
echo ""