# API de Détection de Fraudes

Cette API permet de détecter les fraudes dans les transactions bancaires en utilisant un modèle d'apprentissage automatique.

## Fichiers de modèle

En raison des limitations de taille de GitHub, les fichiers de modèle (.pkl) ne sont pas inclus dans ce dépôt. Vous devez les télécharger séparément et les placer dans le dossier approprié :

### Fichiers requis :

Dans le dossier racine :
- fraud_rf_model.pkl
- fraud_model_calibrated.pkl

Dans le dossier `model/` :
- encoder.pkl
- feature_order.pkl
- fraud_model_calibrated.pkl
- scaler.pkl

## Installation

1. Cloner le dépôt
2. Créer un environnement virtuel : `python -m venv .venv`
3. Activer l'environnement virtuel :
   - Windows : `.venv\Scripts\activate`
   - Linux/Mac : `source .venv/bin/activate`
4. Installer les dépendances : `pip install -r requirements.txt`
5. Télécharger et placer les fichiers de modèle aux emplacements appropriés
6. Lancer l'application : `python app.py`

## Utilisation de l'API

L'API expose les endpoints suivants :

- GET `/health` - Vérifier l'état de l'API
- GET `/schema` - Voir le schéma des données attendues
- POST `/predict` - Prédire la fraude sur une seule transaction
- POST `/predict-batch` - Prédire la fraude sur plusieurs transactions

Voir le dossier `tests/` pour des exemples de requêtes.
