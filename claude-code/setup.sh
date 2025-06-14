#!/bin/bash

# Claude Code Monitoring Setup Script

echo "🚀 Setting up Claude Code monitoring..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Export environment variables for Claude Code telemetry
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=prometheus
export OTEL_EXPORTER_PROMETHEUS_PORT=9464

# Update WSL IP if on WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "🐧 Detected WSL environment, updating IP configuration..."
    ./update-wsl-ip.sh
fi

# Optional: Set metric cardinality (adjust as needed)
# export CLAUDE_CODE_METRIC_CARDINALITY_SESSION_ID=low
# export CLAUDE_CODE_METRIC_CARDINALITY_USER_ID=low
# export CLAUDE_CODE_METRIC_CARDINALITY_PROJECT_PATH=low

echo "✅ Environment variables set:"
echo "   CLAUDE_CODE_ENABLE_TELEMETRY=1"
echo "   OTEL_METRICS_EXPORTER=prometheus"
echo "   OTEL_EXPORTER_PROMETHEUS_PORT=9464"

# Start the monitoring stack
echo ""
echo "🐳 Starting Docker containers..."
if docker compose version &> /dev/null; then
    docker compose up -d
else
    docker-compose up -d
fi

# Wait for services to be ready
echo ""
echo "⏳ Waiting for services to start..."
sleep 10

# Check if services are running
if docker ps | grep -q claude-prometheus && docker ps | grep -q claude-grafana; then
    echo ""
    echo "✅ Monitoring stack is running!"
    echo ""
    echo "📊 Access your dashboards:"
    echo "   - Prometheus: http://localhost:9090"
    echo "   - Grafana: http://localhost:3000 (admin/admin)"
    echo ""
    echo "🔧 Next steps:"
    echo "   1. Start Claude Code with telemetry enabled"
    echo "   2. Metrics will appear in Grafana after Claude Code starts generating them"
    echo ""
    echo "💡 To make telemetry permanent, add these to your shell profile:"
    echo "   export CLAUDE_CODE_ENABLE_TELEMETRY=1"
    echo "   export OTEL_METRICS_EXPORTER=prometheus"
    echo "   export OTEL_EXPORTER_PROMETHEUS_PORT=9464"
else
    echo "❌ Failed to start monitoring stack. Check Docker logs for details."
    exit 1
fi