# SmartPay AP2 - Multi-Agent Payment System
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app/samples/python/src:/app
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml .
COPY samples/python/pyproject.toml ./samples/python/
COPY uv.lock .
COPY requirements-docs.txt .

# Install uv package manager
RUN pip install --no-cache-dir uv

# Install Python dependencies
RUN uv sync --package ap2-samples

# Install the project in editable mode
COPY . .
RUN uv pip install -e . && uv pip install -e samples/python

# Create logs directory
RUN mkdir -p .logs

# Expose ports
EXPOSE 8000 8001 8002 8003 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import sys; sys.exit(0)" || exit 1

# Default command (will be overridden by docker-compose)
CMD ["echo", "SmartPay AP2 Base Image Ready"]
