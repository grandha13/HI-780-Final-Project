# Use official slim Python image
FROM python:3.11-slim

# Create app directory
WORKDIR /app

# Install system dependencies needed by google-cloud libraries (if any)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency list and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY ..

# If this is a web app listening on a port, expose it (example 8080)
EXPOSE 8080

# Default command — replace with your start command or entrypoint script
ENV DBT_PROFILES_DIR=/app
