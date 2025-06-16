# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands for Development

### Claude Code Monitoring
```bash
# Start monitoring stack for Claude Code
cd claude-code && ./setup.sh

# Stop monitoring stack
cd claude-code && ./stop.sh

# Update WSL IP configuration (WSL users only)
cd claude-code && ./update-wsl-ip.sh
```

### Docker Operations
```bash
# View running containers
docker ps

# View container logs
docker compose logs [prometheus|grafana|node-exporter]

# Restart specific service
docker compose restart [prometheus|grafana]

# Clean up volumes (removes all monitoring data)
docker compose down -v
```

### Environment Variables for Claude Code Telemetry
```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=prometheus
export OTEL_EXPORTER_PROMETHEUS_PORT=9464
```

## High-Level Architecture

This is the BMAD Monitoring Framework - a privacy-first monitoring solution for LLM usage across multiple providers. The architecture follows these principles:

1. **Provider Modularity**: Each LLM provider (claude-code, openai, gemini, etc.) has its own monitoring module in separate directories
2. **Shared Components**: Common configurations and templates in `common/` and `templates/` directories
3. **Local Data Storage**: All metrics stay local using Docker volumes (prometheus-data, grafana-data)
4. **Metrics Flow**: LLM Provider → OpenTelemetry → Prometheus → Grafana

### Directory Structure Significance
- `claude-code/`: Fully implemented monitoring solution - reference implementation for other providers
- `common/`: Contains shared metrics specification that all providers must follow
- `templates/`: Base template for adding new provider monitoring
- `providers/`: Future home for additional provider implementations

### Metric Naming Convention
All metrics follow the pattern: `bmad_[provider]_[metric_type]_[unit]`
Examples:
- `claude_code_token_usage_total` (Claude's implementation)
- `bmad_openai_cost_dollars` (future OpenAI implementation)

### Key Configuration Files
- `docker-compose.yml`: Orchestrates Prometheus, Grafana, and Node Exporter containers
- `prometheus.yml`: Defines scrape targets (uses host.docker.internal:9464 for Claude Code)
- `grafana-provisioning/`: Pre-configured dashboards and datasources

### Network Architecture
- Services communicate within Docker network
- Claude Code metrics exposed on host port 9464
- Prometheus scrapes metrics every 15 seconds
- WSL environments require IP updates due to dynamic IP assignment

### BMAD Integration Points
The framework specifically tracks:
- Agent utilization metrics
- Workflow completion rates
- Cross-provider cost comparison
- Team collaboration patterns

When adding new providers, follow the claude-code implementation pattern and ensure metrics align with the specification in `common/metrics-specification.md`.