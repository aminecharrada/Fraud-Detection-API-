FROM python:3.11-slim
WORKDIR /app

# System deps (optional but useful for pandas/scikit-learn wheels)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py ./
COPY model ./model
COPY .env.example ./.env
COPY gunicorn.conf.py ./

ENV PORT=5000
EXPOSE 5000

# Use gunicorn for prod serving
CMD ["gunicorn", "-c", "gunicorn.conf.py", "app:app"]