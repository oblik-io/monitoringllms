# BMAD Monitoring Framework

This directory contains monitoring solutions for various LLM providers used with BMAD-METHOD.

## Structure

```
monitoring/
├── common/           # Shared components and utilities
├── templates/        # Template configurations for new providers
├── providers/        # Provider-specific monitoring (future)
│   ├── openai/      # OpenAI monitoring (planned)
│   ├── gemini/      # Google Gemini monitoring (planned)
│   └── anthropic/   # Anthropic monitoring (planned)
└── claude-code/     # Claude Code monitoring (implemented)
```

## Current Implementations

### Claude Code Monitoring
- **Location**: `./claude-code/`
- **Status**: ✅ Fully implemented
- **Features**: Real-time metrics, cost tracking, token analytics, beautiful dashboards
- **Quick Start**: `cd claude-code && ./setup.sh`

## Adding New Provider Monitoring

To add monitoring for a new LLM provider:

1. Copy the template from `templates/provider-template/`
2. Customize the configuration for your provider
3. Update metrics collection based on provider's API
4. Create provider-specific dashboards
5. Add documentation

## Shared Components

The `common/` directory contains:
- Base docker-compose configurations
- Shared Grafana dashboard components
- Common Prometheus rules
- Utility scripts

## Architecture Principles

1. **Privacy First**: All data stays local
2. **Provider Agnostic**: Easy to add new providers
3. **Minimal Configuration**: Quick setup with sensible defaults
4. **Extensible**: Support for custom metrics and dashboards
5. **BMAD Integration**: Seamless integration with BMAD workflows

## Future Roadmap

- [ ] OpenAI (GPT-4) monitoring support
- [ ] Google Gemini monitoring support
- [ ] Unified dashboard across all providers
- [ ] Cost comparison analytics
- [ ] Performance benchmarking
- [ ] BMAD agent-specific metrics



## Contributing

When adding new provider monitoring:
1. Follow the existing structure
2. Ensure privacy and security
3. Document all configurations
4. Include example dashboards
5. Test with BMAD workflows