# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands for Development

### Starting the monitoring stack
```bash
./setup.sh
```
This script:
- Checks for Docker and Docker Compose installation
- Sets required environment variables for Claude Code telemetry
- Updates WSL IP configuration if running on WSL
- Starts Prometheus, Grafana, and Node Exporter containers

### Stopping the monitoring stack
```bash
./stop.sh
```

### Updating WSL IP (WSL users only)
```bash
./update-wsl-ip.sh
```
Run this if metrics stop appearing after WSL restart, as WSL IP addresses can change.

### Manual Docker operations
```bash
# View running containers
docker ps

# View container logs
docker compose logs [prometheus|grafana|node-exporter]

# Restart specific service
docker compose restart [prometheus|grafana]
```

## Architecture Overview

This is a Docker-based monitoring solution for Claude Code metrics using:

- **Prometheus** (port 9090): Time-series database collecting metrics from Claude Code's OpenTelemetry exporter
- **Grafana** (port 3000): Visualization platform with pre-configured dashboards
- **Node Exporter** (port 9100): Optional system metrics collector

### Key Components

1. **Metrics Collection Flow**:
   - Claude Code exposes metrics via OpenTelemetry on port 9464
   - Prometheus scrapes these metrics every 15 seconds
   - Grafana queries Prometheus for visualization

2. **Configuration Files**:
   - `prometheus.yml`: Defines scrape targets (host.docker.internal:9464 for Claude Code metrics)
   - `docker-compose.yml`: Orchestrates all containers with proper networking
   - `grafana-provisioning/`: Contains datasource and dashboard configurations
     - Two dashboards: Basic and Comprehensive monitoring views

3. **Environment Variables** (required for Claude Code):
   - `CLAUDE_CODE_ENABLE_TELEMETRY=1`
   - `OTEL_METRICS_EXPORTER=prometheus`
   - `OTEL_EXPORTER_PROMETHEUS_PORT=9464`

### Persistent Storage

Docker volumes maintain data between restarts:
- `prometheus-data`: Metrics history
- `grafana-data`: Dashboard customizations and settings

### Network Configuration

- Uses `host.docker.internal` for Docker Desktop environments
- WSL requires IP address updates via `update-wsl-ip.sh`
- All services communicate within Docker network except for Claude Code metrics endpoint