# 🔧 API Troubleshooting Guide

## Problème actuel

L'API `https://fraud-detection-api-3.onrender.com/predict` retourne une erreur 400 avec le message :
```
{"error":"ufunc 'isnan' not supported for the input types, and the inputs could not be safely coerced to any supported types according to the casting rule ''safe''"}
```

## 🔍 Diagnostic

Cette erreur indique un problème de type de données dans le code Python côté serveur. L'erreur `ufunc 'isnan'` se produit généralement quand :

1. **Types de données mixtes** : Le modèle reçoit des types de données qu'il ne peut pas traiter (ex: strings au lieu de floats)
2. **Valeurs manquantes** : Des valeurs `None` ou `NaN` dans des colonnes qui ne les acceptent pas
3. **Format de données incorrect** : La structure des données ne correspond pas à ce que le modèle attend

## 📊 Format des données envoyées par Flutter

L'application Flutter envoie les données dans ce format :
```json
{
  "Transaction_Amount": 100.0,
  "Transaction_Type": 0.0,
  "Account_Balance": 5000.0,
  "Device_Type": 0.0,
  "Location": 123456.0,
  "Merchant_Category": 0.0,
  "IP_Address_Flag": 0.0,
  "Previous_Fraudulent_Activity": 0.0,
  "Daily_Transaction_Count": 1.0,
  "Avg_Transaction_Amount_7d": 100.0,
  "Failed_Transaction_Count_7d": 0.0,
  "Card_Type": 0.0,
  "Card_Age": 365.0,
  "Transaction_Distance": 0.0,
  "Authentication_Method": 0.0,
  "Is_Weekend": 0.0,
  "Hour": 14.0,
  "Month": 8.0,
  "Year": 2025.0
}
```

## 🛠️ Solutions possibles côté serveur Python

### 1. Vérifier le preprocessing des données

```python
import pandas as pd
import numpy as np

def preprocess_data(data):
    # Convertir en DataFrame
    df = pd.DataFrame([data])
    
    # S'assurer que toutes les colonnes sont des floats
    for col in df.columns:
        df[col] = pd.to_numeric(df[col], errors='coerce')
    
    # Remplacer les NaN par des valeurs par défaut
    df = df.fillna(0.0)
    
    # Vérifier les types
    print(f"Data types: {df.dtypes}")
    print(f"Data shape: {df.shape}")
    print(f"Data values: {df.values}")
    
    return df
```

### 2. Vérifier l'ordre des colonnes

Assurez-vous que l'ordre des colonnes correspond à celui utilisé lors de l'entraînement du modèle :

```python
# Ordre attendu par le modèle
expected_columns = [
    'Transaction_Amount', 'Transaction_Type', 'Account_Balance', 
    'Device_Type', 'Location', 'Merchant_Category', 'IP_Address_Flag',
    'Previous_Fraudulent_Activity', 'Daily_Transaction_Count', 
    'Avg_Transaction_Amount_7d', 'Failed_Transaction_Count_7d',
    'Card_Type', 'Card_Age', 'Transaction_Distance', 
    'Authentication_Method', 'Is_Weekend', 'Hour', 'Month', 'Year'
]

# Réorganiser les colonnes
df = df[expected_columns]
```

### 3. Exemple de code Flask corrigé

```python
from flask import Flask, request, jsonify
import pandas as pd
import numpy as np
import joblib

app = Flask(__name__)

# Charger le modèle
model = joblib.load('your_model.pkl')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Récupérer les données JSON
        data = request.get_json()
        
        # Convertir en DataFrame
        df = pd.DataFrame([data])
        
        # S'assurer que toutes les valeurs sont des floats
        for col in df.columns:
            df[col] = pd.to_numeric(df[col], errors='coerce')
        
        # Remplacer les NaN par 0
        df = df.fillna(0.0)
        
        # Faire la prédiction
        prediction = model.predict(df)[0]
        probability = model.predict_proba(df)[0][1]  # Probabilité de fraude
        
        return jsonify({
            'fraud_probability': float(probability),
            'threshold': 0.5,
            'prediction': 'High Risk' if probability > 0.5 else 'Low Risk'
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 400
```

## 🔄 Solution temporaire

En attendant la correction de l'API, l'application Flutter utilise des **données mock intelligentes** qui :

- Calculent le risque basé sur le montant de la transaction
- Prennent en compte l'heure et le jour de la semaine
- Considèrent la méthode d'authentification
- Fournissent des résultats réalistes pour les tests

## 📱 Test de l'application

L'application fonctionne maintenant avec les données mock et affichera :
- ✅ "Using mock data - API server not available" quand l'API a des problèmes
- ✅ Calculs de risque réalistes basés sur les données de transaction
- ✅ Interface complète avec tous les écrans fonctionnels

## 🚀 Prochaines étapes

1. **Corriger l'API Python** avec les solutions ci-dessus
2. **Tester l'API** avec des outils comme Postman ou curl
3. **Retirer le mode mock** une fois l'API fonctionnelle
4. **Ajouter des logs** pour un meilleur debugging
