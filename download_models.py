import os
import requests
import zipfile
from pathlib import Path

def download_models():
    # URL de téléchargement Google Drive (format direct)
    file_id = "1Yr9hl3-ELOumaueUBxGgngNjmOalBR0N"
    url = f"https://drive.google.com/uc?id={file_id}"
    
    # Créer le dossier model s'il n'existe pas
    model_dir = Path("model")
    model_dir.mkdir(exist_ok=True)
    
    # Télécharger le fichier zip
    zip_path = "model_files.zip"
    print("Téléchargement des fichiers de modèle...")
    
    try:
        response = requests.get(url)
        response.raise_for_status()
        
        with open(zip_path, "wb") as f:
            f.write(response.content)
            
        # Extraire les fichiers
        print("Extraction des fichiers...")
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            zip_ref.extractall(".")
            
        # Nettoyer
        os.remove(zip_path)
        print("Fichiers de modèle installés avec succès !")
        
    except Exception as e:
        print(f"Erreur lors du téléchargement des modèles : {str(e)}")
        raise

if __name__ == "__main__":
    download_models()
