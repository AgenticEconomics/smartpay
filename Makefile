# SmartPay AP2 - Docker Compose Makefile

.PHONY: help build up down restart status logs clean

# Default target
help:
	@echo "SmartPay AP2 Docker Compose Manager"
	@echo ""
	@echo "Available commands:"
	@echo "  make build     - Build Docker images"
	@echo "  make up        - Start all services"
	@echo "  make down      - Stop all services"
	@echo "  make restart   - Restart all services"
	@echo "  make status    - Show service status"
	@echo "  make logs      - Show all logs"
	@echo "  make clean     - Clean up Docker resources"
	@echo "  make dev       - Start in development mode"
	@echo ""
	@echo "Examples:"
	@echo "  make up        # Start the system"
	@echo "  make logs      # View logs"
	@echo "  make status    # Check status"

# Build Docker images
build:
	@echo "🏗️  Building Docker images..."
	docker-compose build

# Start all services
up:
	@echo "🚀 Starting SmartPay services..."
	docker-compose up -d
	@echo ""
	@echo "🌐 Service URLs:"
	@echo "  Shopping Agent Web UI: http://localhost:8080"
	@echo "  Merchant Agent API:    http://localhost:8001"
	@echo "  Credentials Provider:  http://localhost:8002"
	@echo "  Payment Processor:     http://localhost:8003"
	@echo ""
	@echo "📊 View logs: make logs"
	@echo "🛑  Stop: make down"

# Stop all services
down:
	@echo "🛑 Stopping SmartPay services..."
	docker-compose down

# Restart all services
restart:
	@echo "🔄 Restarting SmartPay services..."
	docker-compose restart

# Show service status
status:
	@echo "📊 SmartPay Service Status:"
	docker-compose ps
	@echo ""
	@echo "🏥 Health Check:"
	@echo "  Web UI: $$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 || echo "DOWN")"
	@echo "  Merchant: $$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8001/health || echo "DOWN")"
	@echo "  Credentials: $$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8002/health || echo "DOWN")"
	@echo "  Payment: $$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8003/health || echo "DOWN")"

# Show logs
logs:
	@echo "📋 Showing SmartPay logs..."
	docker-compose logs -f

# Clean up Docker resources
clean:
	@echo "🧹 Cleaning up Docker resources..."
	docker-compose down -v --remove-orphans
	docker system prune -f
	@echo "✅ Cleanup completed!"

# Development mode with live reload
dev:
	@echo "👨‍💻 Starting in development mode..."
	docker-compose -f docker-compose.yml -f docker-compose.override.yml up

# Quick start (build + up)
quick-start: build up

# Full reset (clean + build + up)
reset: clean build up

# Test all services
test:
	@echo "🧪 Testing SmartPay services..."
	@echo "Testing Web UI..."
	@curl -s -o /dev/null -w "Web UI: %{http_code}\n" http://localhost:8080 || echo "Web UI: DOWN"
	@echo "Testing Merchant Agent..."
	@curl -s -o /dev/null -w "Merchant: %{http_code}\n" http://localhost:8001/health || echo "Merchant: DOWN"
	@echo "Testing Credentials Provider..."
	@curl -s -o /dev/null -w "Credentials: %{http_code}\n" http://localhost:8002/health || echo "Credentials: DOWN"
	@echo "Testing Payment Processor..."
	@curl -s -o /dev/null -w "Payment: %{http_code}\n" http://localhost:8003/health || echo "Payment: DOWN"
