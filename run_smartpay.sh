#!/bin/bash

# Modified run script for SmartPay AP2 testing
# Adapted for conda environment

set -e

# Project directories
PROJECT_ROOT="/home/ubuntu/smartpay"
SAMPLES_DIR="$PROJECT_ROOT/samples/python/src"
LOGS_DIR="$PROJECT_ROOT/.logs"
ROLES_DIR="$SAMPLES_DIR/roles"

# Environment variables
export GOOGLE_API_KEY="AIzaSyBNDpy1Rg38p5sA88u2NrwNyc6-OvhJBNQ"
export PYTHONPATH="$SAMPLES_DIR:$PROJECT_ROOT"

# Create logs directory
mkdir -p "$LOGS_DIR"

# Function to cleanup background processes
cleanup() {
    echo ""
    echo "Shutting down background processes..."
    if [ ${#pids[@]} -ne 0 ]; then
        kill "${pids[@]}" 2>/dev/null
        wait "${pids[@]}" 2>/dev/null
    fi
    echo "Cleanup complete."
}

# Trap EXIT signal for cleanup
trap cleanup EXIT

# Clear old logs
echo "Clearing old logs..."
rm -f "$LOGS_DIR"/*

# Array to store process IDs
pids=()

echo ""
echo "Starting SmartPay AP2 agents..."

# Start Merchant Agent (port 8001)
echo "-> Starting Merchant Agent (port:8001)..."
cd "$PROJECT_ROOT" && python -m samples.python.src.roles.merchant_agent > "$LOGS_DIR/merchant_agent.log" 2>&1 &
pids+=($!)

# Wait a bit
sleep 3

# Start Credentials Provider Agent (port 8002)
echo "-> Starting Credentials Provider Agent (port:8002)..."
cd "$PROJECT_ROOT" && python -m samples.python.src.roles.credentials_provider_agent > "$LOGS_DIR/credentials_provider_agent.log" 2>&1 &
pids+=($!)

# Wait a bit
sleep 3

# Start Merchant Payment Processor Agent (port 8003)
echo "-> Starting Merchant Payment Processor Agent (port:8003)..."
cd "$PROJECT_ROOT" && python -m samples.python.src.roles.merchant_payment_processor_agent > "$LOGS_DIR/mpp_agent.log" 2>&1 &
pids+=($!)

echo ""
echo "All agents are starting..."
echo "Shopping Agent will start in foreground..."

# Start Shopping Agent (port 8000)
echo "Starting Shopping Agent..."
cd "$PROJECT_ROOT" && adk web --host 0.0.0.0 "$ROLES_DIR"
