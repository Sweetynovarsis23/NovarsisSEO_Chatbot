# Use Python 3.12 slim - has pre-built wheels for all packages
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (better layer caching)
COPY requirements.txt .

# Upgrade pip and install dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose port (Render sets $PORT automatically)
EXPOSE 8000

# Start the application
CMD uvicorn novars2:app --host 0.0.0.0 --port ${PORT:-8000}
