#!/bin/bash

# SmartPay AP2 Docker Compose Launcher
# This script provides an easy way to manage the SmartPay system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."

    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi

    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi

    # Check if .env file exists
    if [ ! -f .env ]; then
        print_warning ".env file not found. Creating from template..."
        if [ -f .env.example ]; then
            cp .env.example .env
            print_warning "Please edit .env file and add your GOOGLE_API_KEY"
            exit 1
        else
            print_error ".env file is required. Please create it with your GOOGLE_API_KEY"
            exit 1
        fi
    fi

    # Check if GOOGLE_API_KEY is set
    if ! grep -q "GOOGLE_API_KEY=" .env || grep -q "GOOGLE_API_KEY=your_" .env; then
        print_error "GOOGLE_API_KEY not found in .env file. Please add it."
        exit 1
    fi

    print_success "Prerequisites check passed!"
}

# Function to build images
build_images() {
    print_info "Building Docker images..."
    if docker-compose build; then
        print_success "Images built successfully!"
    else
        print_error "Failed to build images"
        exit 1
    fi
}

# Function to start services
start_services() {
    print_info "Starting SmartPay services..."

    if docker-compose up -d; then
        print_success "Services started successfully!"

        echo ""
        print_info "Service URLs:"
        echo "  🌐 Shopping Agent Web UI: http://localhost:8080"
        echo "  🏪 Merchant Agent API:    http://localhost:8001"
        echo "  💳 Credentials Provider:  http://localhost:8002"
        echo "  💰 Payment Processor:     http://localhost:8003"

        echo ""
        print_info "To view logs: docker-compose logs -f"
        print_info "To stop services: docker-compose down"
    else
        print_error "Failed to start services"
        exit 1
    fi
}

# Function to stop services
stop_services() {
    print_info "Stopping SmartPay services..."
    if docker-compose down; then
        print_success "Services stopped successfully!"
    else
        print_error "Failed to stop services"
        exit 1
    fi
}

# Function to show status
show_status() {
    print_info "SmartPay Service Status:"
    docker-compose ps

    echo ""
    print_info "Health Check:"
    echo "  Web UI: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 || echo "N/A")"
    echo "  Merchant: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8001/health || echo "N/A")"
    echo "  Credentials: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8002/health || echo "N/A")"
    echo "  Payment: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8003/health || echo "N/A")"
}

# Function to show logs
show_logs() {
    if [ -n "$2" ]; then
        print_info "Showing logs for $2..."
        docker-compose logs -f "$2"
    else
        print_info "Showing all logs..."
        docker-compose logs -f
    fi
}

# Function to restart services
restart_services() {
    if [ -n "$2" ]; then
        print_info "Restarting $2..."
        docker-compose restart "$2"
    else
        print_info "Restarting all services..."
        docker-compose restart
    fi
}

# Function to clean up
cleanup() {
    print_warning "Cleaning up Docker resources..."
    docker-compose down -v --remove-orphans
    docker system prune -f
    print_success "Cleanup completed!"
}

# Main script logic
case "$1" in
    "start"|"up")
        check_prerequisites
        build_images
        start_services
        ;;
    "stop"|"down")
        stop_services
        ;;
    "restart")
        restart_services "$@"
        ;;
    "status"|"ps")
        show_status
        ;;
    "logs")
        show_logs "$@"
        ;;
    "build")
        build_images
        ;;
    "clean")
        cleanup
        ;;
    "help"|*)
        echo "SmartPay AP2 Docker Manager"
        echo ""
        echo "Usage: $0 {command} [options]"
        echo ""
        echo "Commands:"
        echo "  start, up     - Build and start all services"
        echo "  stop, down    - Stop all services"
        echo "  restart       - Restart all services or specific service"
        echo "  status, ps    - Show service status"
        echo "  logs          - Show logs (optionally for specific service)"
        echo "  build         - Build Docker images"
        echo "  clean         - Clean up Docker resources"
        echo "  help          - Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 start"
        echo "  $0 logs shopping-agent"
        echo "  $0 restart merchant-agent"
        ;;
esac
