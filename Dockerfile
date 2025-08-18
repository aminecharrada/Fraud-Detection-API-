FROM python:3.11-slim
WORKDIR /app

# System deps (optional but useful for pandas/scikit-learn wheels)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install requests for downloading models
RUN pip install --no-cache-dir requests

# Copy application files
COPY app.py gunicorn.conf.py download_models.py ./
COPY .env.example ./.env

# Download and extract model files during build
RUN python download_models.py

# Configure environment
ENV PORT=10000
ENV MODEL_DIR=/app/model
ENV PYTHONUNBUFFERED=1

EXPOSE ${PORT}

# Use gunicorn for production serving
CMD ["gunicorn", "-c", "gunicorn.conf.py", "app:app"]