# Claude Code Monitoring

## Features

✨ **Real-time Metrics** - Monitor Claude Code sessions, API costs, and token usage  
📈 **Beautiful Dashboards** - Pre-configured Grafana dashboards with comprehensive visualizations  
🔒 **Privacy First** - All data stays local on your machine  
🐧 **WSL Support** - Automatic configuration for Windows Subsystem for Linux  
💰 **Cost Tracking** - Track API usage costs by model  
📊 **Token Analytics** - Detailed breakdown of token usage including cache efficiency

## Quick Start

1. **Run the setup script:**
   ```bash
   cd claude-code
   ./setup.sh
   ```

2. **Access the dashboards:**
   - Prometheus: http://localhost:9090
   - Grafana: http://localhost:3000 (login: admin/admin)

3. **Start Claude Code with telemetry enabled** (the setup script sets these temporarily):
   ```bash
   export CLAUDE_CODE_ENABLE_TELEMETRY=1
   export OTEL_METRICS_EXPORTER=prometheus
   claude
   ```

## Manual Setup

If you prefer to set up manually:

1. **Set environment variables:**
   ```bash
   export CLAUDE_CODE_ENABLE_TELEMETRY=1
   export OTEL_METRICS_EXPORTER=prometheus
   export OTEL_EXPORTER_PROMETHEUS_PORT=9464
   ```

2. **Start the monitoring stack:**
   ```bash
   docker compose up -d
   ```

3. **Start Claude Code** - metrics will be available at http://localhost:9464/metrics

## Available Metrics

### Core Metrics
- **Session count** (`claude_code_session_count_total`) - Number of Claude Code sessions started
- **Lines of code** (`claude_code_lines_of_code_count_total`) - Lines added/removed with type label
- **API cost** (`claude_code_cost_usage_total`) - Cost in USD by model
- **Token usage** (`claude_code_token_usage_total`) - Tokens by type:
  - `input` - Input tokens sent to model
  - `output` - Output tokens from model
  - `cacheRead` - Tokens read from cache (saves cost!)
  - `cacheCreation` - Tokens stored in cache
- **Tool decisions** (`claude_code_code_edit_tool_decision_total`) - Accept/reject decisions for code edits
- **Service info** (`target_info`) - Claude Code version and service metadata

### Dashboards

Two dashboards are included:

1. **Claude Code Basic** - Simple overview with key metrics
2. **Claude Code Comprehensive Monitoring** - Full dashboard including:
   - Token usage breakdown by type and model
   - Cache hit rate visualization
   - Cost analysis by model over time
   - Lines added vs removed
   - Tool usage patterns (Edit, MultiEdit, Write, NotebookEdit)
   - User-level analytics
   - Real-time graphs and detailed tables

## Configuration Options

### Metric Labels

All metrics include these labels (controlled by cardinality settings):
- `user_id` - Unique user identifier
- `session_id` - Session identifier
- `organization_id` - Organization ID
- `user_email` - User email address
- `user_account_uuid` - Account UUID
- `model` - AI model used (for cost and token metrics)
- `type` - Type of metric (e.g., input/output for tokens, added/removed for lines)
- `tool_name` - Name of the tool (Edit, MultiEdit, Write, NotebookEdit)
- `decision` - Tool decision (accept/reject)

### Metric Cardinality Control

Control the granularity of metrics with these environment variables:

```bash
# Options: high, medium, low, none
export CLAUDE_CODE_METRIC_CARDINALITY_SESSION_ID=low
export CLAUDE_CODE_METRIC_CARDINALITY_USER_ID=low
export CLAUDE_CODE_METRIC_CARDINALITY_PROJECT_PATH=low
```

### Other Exporters

Besides Prometheus, Claude Code supports:

- **OTLP**: `export OTEL_METRICS_EXPORTER=otlp`
- **Console**: `export OTEL_METRICS_EXPORTER=console` (for debugging)

## Stopping the Stack

```bash
./stop.sh
```

## Persistent Configuration

### Option 1: Claude Code Settings (Recommended)

Add to `~/.claude/settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "prometheus",
    "OTEL_EXPORTER_PROMETHEUS_PORT": "9464"
  }
}
```

This will automatically set these environment variables for every Claude Code session.

### Option 2: Shell Profile

Add to your shell profile (~/.bashrc, ~/.zshrc, etc.):

```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=prometheus
export OTEL_EXPORTER_PROMETHEUS_PORT=9464
```

## WSL Users

If you're using WSL, the setup script automatically detects and configures the correct IP address. If you need to manually update the IP:

```bash
./update-wsl-ip.sh
```

This script:
- Detects your current WSL IP address
- Updates the Prometheus configuration
- Restarts Prometheus if it's running

**Note:** WSL IP addresses can change after restart. Run `./update-wsl-ip.sh` if metrics stop appearing.

## Troubleshooting

1. **No metrics appearing:**
   - Ensure Claude Code is running with telemetry enabled
   - Check if metrics are exposed: `curl http://localhost:9464/metrics`
   - Verify Prometheus can reach the metrics endpoint
   - **WSL users**: Run `./update-wsl-ip.sh` to update the IP address

2. **"Context deadline exceeded" errors in Prometheus:**
   - This usually means Prometheus can't reach the metrics endpoint
   - **WSL users**: The WSL IP may have changed - run `./update-wsl-ip.sh`
   - Check if the metrics port is accessible: `curl http://$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'):9464/metrics`

3. **Docker issues:**
   - Ensure Docker daemon is running
   - Check container logs: `docker compose logs`

4. **Port conflicts:**
   - Prometheus (9090), Grafana (3000), Metrics (9464)
   - Modify ports in docker-compose.yml if needed

## Security Notes

- Telemetry is opt-in and requires explicit configuration
- No sensitive information (API keys, file contents) is included in metrics
- All data stays local in your Docker containers