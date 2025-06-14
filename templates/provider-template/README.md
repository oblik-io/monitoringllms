# [Provider Name] Monitoring for BMAD

## Overview

This template provides a starting point for implementing monitoring for a new LLM provider in BMAD-METHOD.

## Quick Start

1. **Copy this template**:
   ```bash
   cp -r monitoring/templates/provider-template monitoring/providers/[provider-name]
   ```

2. **Customize configuration**:
   - Update `prometheus.yml` with provider-specific metrics endpoints
   - Modify `docker-compose.yml` if additional services are needed
   - Create provider-specific dashboards in `grafana-provisioning/dashboards/`

3. **Run the monitoring stack**:
   ```bash
   ./setup.sh
   ```

## Configuration Steps

### 1. Metrics Endpoint

Update the metrics endpoint in `prometheus.yml`:
```yaml
scrape_configs:
  - job_name: '[provider-name]'
    static_configs:
      - targets: ['[metrics-endpoint]:[port]']
```

### 2. Environment Variables

Add provider-specific environment variables:
```bash
export [PROVIDER]_ENABLE_TELEMETRY=1
export [PROVIDER]_METRICS_PORT=9464
```

### 3. Dashboard Creation

Create dashboards that track:
- API usage and costs
- Token consumption
- Response times
- Error rates
- Cache efficiency (if applicable)

## Provider-Specific Metrics

Define metrics based on your provider's capabilities:
- `[provider]_api_calls_total` - Total API calls
- `[provider]_tokens_used_total` - Token usage
- `[provider]_cost_total` - Cost tracking
- `[provider]_response_time_seconds` - Response latency

## Integration with BMAD

Ensure the monitoring integrates with BMAD workflows:
1. Track agent-specific usage
2. Monitor workflow execution
3. Measure team performance

## Testing

1. Verify metrics are exposed
2. Check Prometheus scraping
3. Validate dashboard functionality
4. Test with BMAD agents

## Troubleshooting

Common issues and solutions:
- Metrics not appearing: Check endpoint connectivity
- Dashboard errors: Verify metric names match
- Performance issues: Adjust scrape intervals