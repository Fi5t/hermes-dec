FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY setup.py .
COPY src/ ./src/

RUN pip install --no-cache-dir .

RUN adduser --disabled-password --gecos "" hermes-dec \
    && chown -R hermes-dec:hermes-dec /app

USER hermes-dec
