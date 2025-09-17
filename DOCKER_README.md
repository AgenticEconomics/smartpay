# SmartPay AP2 - Docker Compose Setup

This guide explains how to run the SmartPay Agent Payments Protocol system using Docker Compose.

## Prerequisites

- Docker and Docker Compose installed
- Google API Key for Gemini AI models

## Quick Start

### Option 1: Using Make (Recommended)

```bash
# Set up environment
cp env.template .env
# Edit .env and add your GOOGLE_API_KEY

# Quick start
make quick-start

# Or step by step:
make build  # Build images
make up     # Start services
make status # Check status
```

### Option 2: Using Docker Start Script

```bash
# Set up environment
cp env.template .env
# Edit .env and add your GOOGLE_API_KEY

# Start the system
./docker-start.sh start

# Check status
./docker-start.sh status
```

### Option 3: Using Docker Compose Directly

```bash
# Set up environment
cp env.template .env
# Edit .env and add your GOOGLE_API_KEY

# Build and run
docker-compose build
docker-compose up -d
```

### 4. Access the system

- **Shopping Agent Web UI**: http://localhost:8080
- **Merchant Agent API**: http://localhost:8001
- **Credentials Provider API**: http://localhost:8002
- **Payment Processor API**: http://localhost:8003

## Management Commands

### Using Make

```bash
make up           # Start services
make down         # Stop services
make restart      # Restart services
make status       # Show status
make logs         # Show logs
make clean        # Clean up
```

### Using Docker Start Script

```bash
./docker-start.sh start     # Start all services
./docker-start.sh stop      # Stop all services
./docker-start.sh restart   # Restart services
./docker-start.sh status    # Show status
./docker-start.sh logs      # Show logs
./docker-start.sh clean     # Clean up
```

### Using Docker Compose

```bash
docker-compose up -d        # Start
docker-compose down         # Stop
docker-compose restart      # Restart
docker-compose ps           # Status
docker-compose logs -f      # Logs
```

## Services Overview

### 1. Merchant Agent (Port 8001)
- **Purpose**: Handles product queries and cart management
- **Technology**: A2A Protocol + ADK
- **Health Check**: `http://localhost:8001/health`

### 2. Credentials Provider Agent (Port 8002)
- **Purpose**: Manages user payment credentials
- **Technology**: A2A Protocol + ADK
- **Health Check**: `http://localhost:8002/health`

### 3. Merchant Payment Processor Agent (Port 8003)
- **Purpose**: Processes payments and handles transactions
- **Technology**: A2A Protocol + ADK
- **Health Check**: `http://localhost:8003/health`

### 4. Shopping Agent (Port 8080)
- **Purpose**: Main orchestrator with web interface
- **Technology**: ADK Web Interface
- **Health Check**: `http://localhost:8080`

## Configuration

### Environment Variables

Create a `.env` file with the following variables:

```bash
# Required
GOOGLE_API_KEY=your_google_api_key_here

# Optional
LOG_LEVEL=INFO
DEBUG=false
```

### Custom Configuration

Use `docker-compose.override.yml` to customize the deployment:

```yaml
services:
  shopping-agent:
    environment:
      - LOG_LEVEL=DEBUG
    ports:
      - "18080:8080"  # Custom port mapping
```

## Development Workflow

### Running in development mode

```bash
# Start with live reload
docker-compose -f docker-compose.yml -f docker-compose.override.yml up

# View specific service logs
docker-compose logs shopping-agent

# Restart a specific service
docker-compose restart shopping-agent
```

### Debugging

```bash
# Run with debug logging
docker-compose up --scale log-watcher=1

# Access container shell
docker-compose exec shopping-agent bash

# View all logs
docker-compose logs
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: Change ports in `docker-compose.override.yml`
2. **API key issues**: Ensure `GOOGLE_API_KEY` is set in `.env`
3. **Build failures**: Clear Docker cache with `docker system prune`

### Health Checks

All services include health checks. Use these commands to verify:

```bash
# Check service health
docker-compose ps

# Test specific endpoints
curl http://localhost:8080
curl http://localhost:8001/health
```

### Logs and Monitoring

```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f shopping-agent

# Export logs for analysis
docker-compose logs > smartpay_logs.txt
```

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   User Browser  │───▶│ Shopping Agent   │───▶│ Merchant Agent  │
│   (Port 8080)   │    │   (ADK Web)      │    │   (Port 8001)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│Credentials      │    │ Payment Method   │    │Merchant Payment │
│Provider (8002)  │    │  Selection       │    │Processor (8003) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Production Deployment

For production deployment, consider:

1. **Security**: Use secrets management instead of .env files
2. **Scaling**: Adjust replica counts based on load
3. **Monitoring**: Add logging and metrics collection
4. **Networking**: Configure proper network isolation
5. **Persistence**: Add volume mounts for data persistence

## API Documentation

Once running, you can access:

- **ADK Web UI**: Interactive agent interface
- **REST APIs**: Direct API access to each agent
- **Health Endpoints**: Service health monitoring
- **Logs**: Comprehensive request/response logging

## Support

For issues or questions:
1. Check the logs: `docker-compose logs`
2. Verify configuration: `docker-compose config`
3. Test individual services: `docker-compose exec <service> bash`
