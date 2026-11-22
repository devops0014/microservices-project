
# Use the same Python version used to generate requirements.txt
FROM python:3.10-slim AS base

# Builder stage
FROM base AS builder

# Install system build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Copy requirements
COPY requirements.txt .

# Install compatible build dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir "setuptools==80.9.0" wheel

# Install Python dependencies
RUN pip install --no-cache-dir --no-build-isolation \
    -r requirements.txt


# Runtime stage
FROM base AS runtime

ENV PYTHONUNBUFFERED=1
ENV PORT=8080

WORKDIR /recommendationservice

# Copy installed Python packages
COPY --from=builder /usr/local/lib/python3.10/ /usr/local/lib/python3.10/

# Copy application
COPY . .

EXPOSE 8080

ENTRYPOINT ["python", "email_server.py"]
