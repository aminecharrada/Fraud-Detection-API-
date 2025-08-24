from flask import Flask, request, jsonify
import pandas as pd
import numpy as np
import joblib
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Charger le modèle (remplacez par le chemin de votre modèle)
try:
    model = joblib.load('fraud_detection_model.pkl')
    print("✅ Model loaded successfully")
except Exception as e:
    print(f"❌ Error loading model: {e}")
    model = None

# Dictionnaires d'encodage pour convertir les valeurs textuelles en numériques
ENCODING_MAPS = {
    'Transaction_Type': {
        'Debit': 0, 'Credit': 1, 'POS': 2, 'ATM Withdrawal': 3, 'Bank Transfer': 4
    },
    'Device_Type': {
        'Mobile': 0, 'Tablet': 1, 'Web': 2, 'Laptop': 3
    },
    'Merchant_Category': {
        'Electronics': 0, 'Travel': 1, 'Clothing': 2, 'Restaurants': 3, 
        'Grocery': 4, 'Gas Station': 5
    },
    'Card_Type': {
        'Visa': 0, 'MasterCard': 1, 'Amex': 2, 'Discover': 3
    },
    'Authentication_Method': {
        'PIN': 0, 'OTP': 1, 'Password': 2, 'Biometric': 3, 'None': 4
    },
    'Location': {
        'Nigeria': 123456, 'USA': 234567, 'UK': 345678, 'France': 456789,
        'Germany': 567890, 'Canada': 678901, 'Unknown': 0
    }
}

# Ordre des colonnes attendu par le modèle
EXPECTED_COLUMNS = [
    'Transaction_Amount', 'Transaction_Type', 'Account_Balance', 
    'Device_Type', 'Location', 'Merchant_Category', 'IP_Address_Flag',
    'Previous_Fraudulent_Activity', 'Daily_Transaction_Count', 
    'Avg_Transaction_Amount_7d', 'Failed_Transaction_Count_7d',
    'Card_Type', 'Card_Age', 'Transaction_Distance', 
    'Authentication_Method', 'Is_Weekend', 'Hour', 'Month', 'Year'
]

def encode_categorical_data(data):
    """Convertit les données textuelles en valeurs numériques"""
    encoded_data = data.copy()
    
    for column, value in encoded_data.items():
        if column in ENCODING_MAPS and isinstance(value, str):
            # Convertir la valeur textuelle en numérique
            encoded_data[column] = ENCODING_MAPS[column].get(value, 0)
            print(f"🔄 Encoded {column}: '{value}' -> {encoded_data[column]}")
    
    return encoded_data

def preprocess_data(data):
    """Préprocesse les données pour le modèle"""
    try:
        print(f"📥 Raw input data: {data}")
        
        # 1. Encoder les données catégorielles
        encoded_data = encode_categorical_data(data)
        print(f"🔢 Encoded data: {encoded_data}")
        
        # 2. Convertir en DataFrame
        df = pd.DataFrame([encoded_data])
        print(f"📊 DataFrame shape: {df.shape}")
        print(f"📊 DataFrame columns: {list(df.columns)}")
        
        # 3. S'assurer que toutes les colonnes attendues sont présentes
        for col in EXPECTED_COLUMNS:
            if col not in df.columns:
                df[col] = 0.0  # Valeur par défaut
                print(f"➕ Added missing column '{col}' with default value 0.0")
        
        # 4. Réorganiser les colonnes dans l'ordre attendu
        df = df[EXPECTED_COLUMNS]
        print(f"🔄 Reordered columns: {list(df.columns)}")
        
        # 5. Convertir toutes les valeurs en float
        for col in df.columns:
            df[col] = pd.to_numeric(df[col], errors='coerce')
        
        # 6. Remplacer les NaN par des valeurs par défaut
        df = df.fillna(0.0)
        
        # 7. Vérifications finales
        print(f"✅ Final DataFrame shape: {df.shape}")
        print(f"✅ Data types: {df.dtypes.to_dict()}")
        print(f"✅ Sample values: {df.iloc[0].to_dict()}")
        
        # 8. Vérifier qu'il n'y a pas de NaN
        if df.isnull().any().any():
            print("⚠️ Warning: NaN values detected!")
            df = df.fillna(0.0)
        
        return df
        
    except Exception as e:
        print(f"❌ Error in preprocessing: {e}")
        raise e

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        'message': 'Fraud Detection API is running!',
        'endpoints': {
            '/predict': 'POST - Make fraud prediction',
            '/health': 'GET - Check API health'
        },
        'model_loaded': model is not None
    })

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'healthy',
        'model_loaded': model is not None,
        'expected_features': EXPECTED_COLUMNS
    })

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Vérifier que le modèle est chargé
        if model is None:
            return jsonify({'error': 'Model not loaded'}), 500
        
        # Récupérer les données JSON
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No JSON data provided'}), 400
        
        print(f"🚀 Received prediction request")
        
        # Préprocesser les données
        df = preprocess_data(data)
        
        # Faire la prédiction
        print("🔮 Making prediction...")
        prediction = model.predict(df)[0]
        probability = model.predict_proba(df)[0][1]  # Probabilité de fraude (classe 1)
        
        print(f"📊 Prediction: {prediction}")
        print(f"📊 Fraud probability: {probability}")
        
        # Déterminer le niveau de risque
        threshold = 0.5
        risk_level = 'High Risk' if probability > threshold else 'Low Risk'
        
        result = {
            'fraud_probability': float(probability),
            'threshold': float(threshold),
            'prediction': risk_level,
            'raw_prediction': int(prediction),
            'success': True
        }
        
        print(f"✅ Returning result: {result}")
        return jsonify(result)
        
    except Exception as e:
        error_msg = f"Prediction error: {str(e)}"
        print(f"❌ {error_msg}")
        return jsonify({'error': error_msg}), 400

@app.route('/test', methods=['POST'])
def test_endpoint():
    """Endpoint de test pour vérifier le preprocessing sans faire de prédiction"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No JSON data provided'}), 400
        
        # Préprocesser les données
        df = preprocess_data(data)
        
        return jsonify({
            'message': 'Preprocessing successful',
            'processed_data': df.iloc[0].to_dict(),
            'shape': df.shape,
            'columns': list(df.columns)
        })
        
    except Exception as e:
        return jsonify({'error': f'Preprocessing error: {str(e)}'}), 400

if __name__ == '__main__':
    print("🚀 Starting Fraud Detection API...")
    print(f"📋 Expected columns: {EXPECTED_COLUMNS}")
    print(f"🔢 Encoding maps loaded: {list(ENCODING_MAPS.keys())}")
    app.run(debug=True, host='0.0.0.0', port=5000)
