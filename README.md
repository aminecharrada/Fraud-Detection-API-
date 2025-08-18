# API de Détection de Fraudes

Cette API permet de détecter les fraudes dans les transactions bancaires en utilisant un modèle d'apprentissage automatique.

## Fichiers de modèle

En raison des limitations de taille de GitHub, les fichiers de modèle (.pkl) sont hébergés sur Google Drive. Suivez ces étapes pour les installer :

1. [Téléchargez les fichiers de modèle](https://drive.google.com/file/d/1Yr9hl3-ELOumaueUBxGgngNjmOalBR0N/view?usp=sharing)
2. Extrayez le fichier `model_files.zip` dans le dossier du projet
3. Vérifiez que les fichiers suivants sont présents dans le dossier `model/` :
   - encoder.pkl
   - feature_order.pkl
   - fraud_model_calibrated.pkl
   - scaler.pkl

La structure du dossier `model/` devrait ressembler à ceci :
```
model/
├── encoder.pkl
├── feature_order.pkl
├── fraud_model_calibrated.pkl
└── scaler.pkl
```

## Installation

1. Cloner le dépôt :
   ```bash
   git clone https://github.com/aminecharrada/Fraud-Detection-API-.git
   cd Fraud-Detection-API-
   ```

2. Télécharger et extraire les fichiers de modèle :
   - Téléchargez [model_files.zip](https://drive.google.com/file/d/1Yr9hl3-ELOumaueUBxGgngNjmOalBR0N/view?usp=sharing)
   - Extrayez le contenu dans le dossier du projet
   - Vérifiez que le dossier `model/` contient tous les fichiers .pkl requis

3. Créer et activer l'environnement virtuel :
   ```bash
   # Création de l'environnement virtuel
   python -m venv .venv

   # Activation de l'environnement virtuel
   # Sur Windows :
   .venv\Scripts\activate
   # Sur Linux/Mac :
   source .venv/bin/activate
   ```

4. Installer les dépendances :
   ```bash
   pip install -r requirements.txt
   ```

5. Lancer l'application :
   ```bash
   python app.py
   ```

L'API sera accessible à l'adresse : http://localhost:5000

## Utilisation de l'API

L'API expose les endpoints suivants :

- GET `/health` - Vérifier l'état de l'API
- GET `/schema` - Voir le schéma des données attendues
- POST `/predict` - Prédire la fraude sur une seule transaction
- POST `/predict-batch` - Prédire la fraude sur plusieurs transactions

Voir le dossier `tests/` pour des exemples de requêtes.
