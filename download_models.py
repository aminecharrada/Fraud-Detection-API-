import os
import requests
import zipfile
from pathlib import Path

def download_models():
    """Télécharge et extrait les fichiers de modèle."""
    # URL de téléchargement direct
    url = os.getenv('MODEL_DOWNLOAD_URL', 'https://github.com/aminecharrada/Fraud-Detection-API-/releases/download/v1.0/model_files.zip')
    
    # Créer le dossier model s'il n'existe pas
    model_dir = Path(os.getenv('MODEL_DIR', 'model'))
    model_dir.mkdir(exist_ok=True)
    
    # Chemin du fichier zip
    zip_path = model_dir / "model_files.zip"
    
    print(f"Téléchargement des modèles depuis {url}...")
    try:
        # Téléchargement avec barre de progression
        response = requests.get(url, stream=True)
        response.raise_for_status()
        
        total_size = int(response.headers.get('content-length', 0))
        block_size = 8192
        
        with open(zip_path, 'wb') as f:
            for data in response.iter_content(block_size):
                f.write(data)
        
        print("Extraction des fichiers...")
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(model_dir)
        
        # Nettoyage
        os.remove(zip_path)
        print(f"Modèles installés avec succès dans {model_dir} !")
        
        # Vérification des fichiers requis
        required_files = ['encoder.pkl', 'feature_order.pkl', 'fraud_model_calibrated.pkl', 'scaler.pkl']
        missing_files = [f for f in required_files if not (model_dir / f).exists()]
        
        if missing_files:
            raise FileNotFoundError(f"Fichiers manquants après extraction : {', '.join(missing_files)}")
            
    except Exception as e:
        print(f"Erreur lors du téléchargement des modèles : {str(e)}")
        if zip_path.exists():
            os.remove(zip_path)
        raise

if __name__ == "__main__":
    download_models()
