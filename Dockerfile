FROM python:3.11-slim
WORKDIR /app

# Installation des dépendances système
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Installation des dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt requests gunicorn

# Copie des fichiers d'application
COPY . .

# Configuration de l'environnement
ENV PORT=10000 \
    MODEL_DIR=/app/model \
    PYTHONUNBUFFERED=1 \
    MODEL_DOWNLOAD_URL=""

# Création du dossier model
RUN mkdir -p ${MODEL_DIR}

# Script de démarrage
COPY <<EOF /app/start.sh
#!/bin/sh
# Téléchargement des modèles au démarrage
python download_models.py
# Démarrage de l'application
exec gunicorn -c gunicorn.conf.py app:app
EOF

RUN chmod +x /app/start.sh

EXPOSE ${PORT}

# Utilisation du script de démarrage
CMD ["/app/start.sh"]