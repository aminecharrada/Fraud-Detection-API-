import os
import json
import joblib
import pandas as pd
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv

load_dotenv()


MODEL_DIR = os.getenv("MODEL_DIR", "./model")
MODEL_BUNDLE = os.getenv("MODEL_BUNDLE", "").strip()  # optional single-file bundle
DEFAULT_THRESHOLD = float(os.getenv("THRESHOLD", 0.5))
PORT = int(os.getenv("PORT", 5000))


CATEGORICAL_FEATURES = [
    'Transaction_Type', 'Device_Type', 'Location', 'Merchant_Category',
    'Card_Type', 'Authentication_Method', 'Hour', 'Month', 'Year'
]
NUMERIC_FEATURES = [
    'Transaction_Amount', 'Account_Balance', 'Daily_Transaction_Count',
    'Avg_Transaction_Amount_7d', 'Failed_Transaction_Count_7d', 'Card_Age',
    'Transaction_Distance'
]
BOOLEAN_FEATURES = ['IP_Address_Flag', 'Is_Weekend', 'Previous_Fraudulent_Activity']
RAW_FEATURES = NUMERIC_FEATURES + BOOLEAN_FEATURES + CATEGORICAL_FEATURES

# ------------------------------
# Load artifacts
# ------------------------------
model = None
encoder = None
scaler = None
feature_order = None
threshold_used = DEFAULT_THRESHOLD

if MODEL_BUNDLE:
    # Single-file bundle mode (optional)
    bundle = joblib.load(MODEL_BUNDLE)
    model = bundle["model"]
    threshold_used = float(bundle.get("threshold", DEFAULT_THRESHOLD))
    feature_order = bundle["feature_order"]
    # When using a Pipeline inside bundle, encoder/scaler live inside it
else:
    # Separate artifacts mode (your current setup)
    model = joblib.load(os.path.join(MODEL_DIR, 'fraud_model_calibrated.pkl'))
    encoder = joblib.load(os.path.join(MODEL_DIR, 'encoder.pkl'))
    scaler = joblib.load(os.path.join(MODEL_DIR, 'scaler.pkl'))
    feature_order = joblib.load(os.path.join(MODEL_DIR, 'feature_order.pkl'))

# Allow env THRESHOLD to override any stored/default threshold
threshold_env = os.getenv("THRESHOLD")
if threshold_env is not None:
    threshold_used = float(threshold_env)

# ------------------------------
# Flask app
# ------------------------------
app = Flask(__name__)

# Enable CORS for all routes to allow Flutter Web requests
CORS(app, origins=["*"], methods=["GET", "POST", "OPTIONS"],
     allow_headers=["Content-Type", "Accept", "User-Agent"])



# ------------------------------
# Preprocessing 
# ------------------------------

def preprocess_frame(df_raw: pd.DataFrame) -> pd.DataFrame:
    """Transform a raw input frame into the exact training schema order."""
    
    missing = [c for c in RAW_FEATURES if c not in df_raw.columns]
    for c in missing:
        df_raw[c] = None

    
    for b in BOOLEAN_FEATURES:
        if df_raw[b].dtype == bool:
            df_raw[b] = df_raw[b].astype(int)

    
    X_cats = df_raw[CATEGORICAL_FEATURES]
    X_nums = df_raw[NUMERIC_FEATURES]
    X_bools = df_raw[BOOLEAN_FEATURES]

   
    X_cat_enc = encoder.transform(X_cats)
    X_num_scl = scaler.transform(X_nums)

    
    enc_cols = encoder.get_feature_names_out(CATEGORICAL_FEATURES)
    df_enc = pd.DataFrame(X_cat_enc, columns=enc_cols, index=df_raw.index)
    df_num = pd.DataFrame(X_num_scl, columns=NUMERIC_FEATURES, index=df_raw.index)
    df_bool = X_bools.reset_index(drop=True)

    
    df_proc = pd.concat([df_num.reset_index(drop=True), df_bool.reset_index(drop=True), df_enc.reset_index(drop=True)], axis=1)
    df_proc = df_proc.reindex(columns=feature_order, fill_value=0)
    return df_proc

# ------------------------------
# Utility routes
# ------------------------------

@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "Fraud Detection API is running!",
        "endpoints": {
            "/predict": "POST - Make fraud prediction",
            "/health": "GET - Check API health"
        },
        "model_loaded": model is not None
    })

@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "healthy",
        "model_loaded": model is not None,
        "threshold": threshold_used
    })

# ------------------------------
# Prediction routes
# ------------------------------

@app.route("/predict", methods=["POST", "OPTIONS"])
def predict_single():
    # Handle preflight OPTIONS request
    if request.method == "OPTIONS":
        response = jsonify({"message": "CORS preflight"})
        response.headers.add("Access-Control-Allow-Origin", "*")
        response.headers.add("Access-Control-Allow-Headers", "Content-Type,Accept,User-Agent")
        response.headers.add("Access-Control-Allow-Methods", "POST,OPTIONS")
        return response

    try:
        payload = request.get_json(force=True)
        if not isinstance(payload, dict):
            return jsonify({"error": "Send a JSON object for single /predict."}), 400
        df = pd.DataFrame([payload])

        if MODEL_BUNDLE:
            # Bundle mode assumes a full Pipeline inside model
            proba = model.predict_proba(df)[:, 1]
        else:
            df_proc = preprocess_frame(df)
            proba = model.predict_proba(df_proc)[:, 1]

        p = float(proba[0])
        pred = int(p >= threshold_used)

        response = jsonify({
            "prediction": pred,
            "fraud_probability": round(p, 4),
            "threshold_used": threshold_used
        })

        # Add CORS headers manually
        response.headers.add("Access-Control-Allow-Origin", "*")
        response.headers.add("Access-Control-Allow-Headers", "Content-Type,Accept,User-Agent")
        return response

    except Exception as e:
        error_response = jsonify({"error": str(e)})
        error_response.headers.add("Access-Control-Allow-Origin", "*")
        return error_response, 400

# @app.post("/predict-batch")
# def predict_batch():
#     try:
#         payload = request.get_json(force=True)
#         if not isinstance(payload, list):
#             return jsonify({"error": "Send a JSON array for /predict-batch."}), 400
#         df = pd.DataFrame(payload)

#         if MODEL_BUNDLE:
#             proba = model.predict_proba(df)[:, 1]
#         else:
#             df_proc = preprocess_frame(df)
#             proba = model.predict_proba(df_proc)[:, 1]

#         preds = (proba >= threshold_used).astype(int)
#         results = [
#             {"index": int(i), "prediction": int(preds[i]), "fraud_probability": float(round(proba[i], 4))}
#             for i in range(len(preds))
#         ]
#         return jsonify({"threshold_used": threshold_used, "results": results})
#     except Exception as e:
#         return jsonify({"error": str(e)}), 400

if __name__ == "__main__":
    # For dev only. Use gunicorn in production.
    app.run(host="0.0.0.0", port=PORT, debug=True)