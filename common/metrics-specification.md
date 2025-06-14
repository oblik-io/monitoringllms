# LLM Provider Metrics Specification

This document defines standard metrics that should be implemented for each LLM provider monitoring integration.

## Core Metrics (Required)

### 1. Usage Metrics
```
# API Calls
bmad_[provider]_api_calls_total{
  model="",
  endpoint="",
  status="success|failure",
  agent="",
  workflow=""
}

# Token Usage
bmad_[provider]_tokens_total{
  model="",
  type="input|output|cache_read|cache_creation",
  agent="",
  workflow=""
}

# Cost Tracking
bmad_[provider]_cost_dollars_total{
  model="",
  operation="",
  agent="",
  workflow=""
}
```

### 2. Performance Metrics
```
# Response Time
bmad_[provider]_response_time_seconds{
  model="",
  operation="",
  agent=""
}

# Error Rate
bmad_[provider]_errors_total{
  model="",
  error_type="",
  agent=""
}
```

### 3. BMAD Integration Metrics
```
# Agent Usage
bmad_agent_invocations_total{
  provider="",
  agent_type="",
  workflow=""
}

# Workflow Progress
bmad_workflow_steps_completed_total{
  provider="",
  workflow="",
  step=""
}

# Team Collaboration
bmad_team_handoffs_total{
  from_agent="",
  to_agent="",
  workflow=""
}
```

## Provider-Specific Examples

### OpenAI (GPT-4)
```
bmad_openai_api_calls_total
bmad_openai_tokens_total{type="prompt|completion"}
bmad_openai_cost_dollars_total{model="gpt-4|gpt-4-turbo|gpt-3.5-turbo"}
bmad_openai_function_calls_total{function_name=""}
bmad_openai_embeddings_generated_total
```

### Google Gemini
```
bmad_gemini_api_calls_total
bmad_gemini_tokens_total{type="input|output"}
bmad_gemini_cost_dollars_total{model="gemini-pro|gemini-pro-vision"}
bmad_gemini_multimodal_requests_total{type="text|image|audio"}
bmad_gemini_safety_blocks_total{category=""}
```

### Anthropic Claude
```
bmad_anthropic_api_calls_total
bmad_anthropic_tokens_total{type="input|output|cache"}
bmad_anthropic_cost_dollars_total{model="claude-3-opus|claude-3-sonnet"}
bmad_anthropic_cache_hits_total
bmad_anthropic_context_window_usage_ratio
```

### Local Models (Ollama/LM Studio)
```
bmad_local_inference_requests_total{model=""}
bmad_local_tokens_per_second{model="",type="prompt|generation"}
bmad_local_memory_usage_bytes{model=""}
bmad_local_gpu_utilization_percent{model=""}
```

## Metric Labels

### Required Labels
- `provider`: LLM provider name
- `model`: Specific model used
- `agent`: BMAD agent type (if applicable)
- `workflow`: BMAD workflow name (if applicable)

### Optional Labels
- `user_id`: Unique user identifier
- `session_id`: Session identifier
- `project`: Project name
- `environment`: dev|staging|production
- `team`: BMAD team name

## Aggregation Guidelines

### Time-based Aggregations
- 1-minute rate for real-time monitoring
- 5-minute average for dashboards
- Hourly/daily totals for cost analysis

### Dimension Aggregations
- By model for cost optimization
- By agent for performance analysis
- By workflow for process improvement
- By team for collaboration insights

## Dashboard Metrics

### Overview Dashboard
1. Total API calls (last 24h)
2. Total cost (current month)
3. Average response time
4. Error rate percentage
5. Top agents by usage
6. Cost by model breakdown

### Agent Performance Dashboard
1. Invocations per agent
2. Success rate per agent
3. Average execution time
4. Token efficiency
5. Cost per task completed

### Workflow Analytics Dashboard
1. Workflow completion rate
2. Average workflow duration
3. Bottleneck identification
4. Agent handoff efficiency
5. Cost per workflow

## Implementation Notes

1. **Metric Collection**: Use OpenTelemetry when possible
2. **Cardinality**: Keep label combinations under control
3. **Sampling**: Implement for high-volume metrics
4. **Retention**: Define based on metric importance
5. **Security**: Never include sensitive data in labels