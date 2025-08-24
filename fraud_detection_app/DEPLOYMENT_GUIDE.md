# 🚀 Guide de déploiement de l'API corrigée

## 📁 Fichiers créés

1. **`corrected_api.py`** - API Flask corrigée avec gestion des données textuelles et numériques
2. **`test_corrected_api.py`** - Script de test pour vérifier l'API
3. **`requirements.txt`** - Dépendances Python nécessaires

## 🔧 Corrections apportées

### 1. **Gestion des données mixtes**
- ✅ Accepte les données numériques de Flutter (ex: `"Transaction_Type": 0.0`)
- ✅ Accepte les données textuelles (ex: `"Transaction_Type": "Debit"`)
- ✅ Conversion automatique texte → numérique avec dictionnaires d'encodage

### 2. **Preprocessing robuste**
- ✅ Vérification et ajout des colonnes manquantes
- ✅ Réorganisation dans l'ordre attendu par le modèle
- ✅ Conversion forcée en float pour éviter les erreurs `ufunc 'isnan'`
- ✅ Remplacement des NaN par des valeurs par défaut

### 3. **Endpoints supplémentaires**
- ✅ `/health` - Vérification de l'état de l'API
- ✅ `/test` - Test du preprocessing sans prédiction
- ✅ `/` - Page d'accueil avec documentation

### 4. **Gestion d'erreurs améliorée**
- ✅ Messages d'erreur détaillés
- ✅ Logs de debugging
- ✅ Validation des données d'entrée

## 🏗️ Déploiement sur Render

### Étape 1: Préparer les fichiers
```bash
# Assurez-vous d'avoir ces fichiers dans votre repo :
corrected_api.py
requirements.txt
fraud_detection_model.pkl  # Votre modèle entraîné
```

### Étape 2: Configuration Render
1. **Build Command**: `pip install -r requirements.txt`
2. **Start Command**: `gunicorn corrected_api:app`
3. **Environment**: `Python 3`

### Étape 3: Variables d'environnement (optionnel)
```
FLASK_ENV=production
```

## 🧪 Test local

### 1. Installation des dépendances
```bash
pip install -r requirements.txt
```

### 2. Lancement de l'API
```bash
python corrected_api.py
```

### 3. Test de l'API
```bash
python test_corrected_api.py
```

## 📊 Formats de données supportés

### Format Flutter (numérique)
```json
{
  "Transaction_Amount": 900000.0,
  "Transaction_Type": 0.0,
  "Device_Type": 2.0,
  "Location": 123456.0,
  "Merchant_Category": 0.0,
  "Card_Type": 0.0,
  "Authentication_Method": 1.0
}
```

### Format textuel
```json
{
  "Transaction_Amount": 900000.0,
  "Transaction_Type": "Debit",
  "Device_Type": "Web",
  "Location": "Nigeria",
  "Merchant_Category": "Electronics",
  "Card_Type": "Visa",
  "Authentication_Method": "OTP"
}
```

## 🔄 Mise à jour de l'URL Flutter

Une fois l'API déployée, mettez à jour l'URL dans Flutter :

```dart
// Dans lib/services/api_service.dart
static const String baseUrl = 'https://VOTRE-NOUVEAU-URL.onrender.com';
```

## ✅ Vérifications post-déploiement

1. **Test de santé** : `GET /health`
2. **Test avec données Flutter** : `POST /predict` avec données numériques
3. **Test avec données textuelles** : `POST /predict` avec données texte
4. **Test de l'app Flutter** : Vérifier que "Using mock data" disparaît

## 🎯 Résultat attendu

Après déploiement, l'application Flutter devrait :
- ✅ Se connecter à l'API sans erreur
- ✅ Recevoir de vraies prédictions au lieu de données mock
- ✅ Afficher les probabilités de fraude calculées par le modèle
- ✅ Ne plus montrer le message "Using mock data"

## 🔧 Dépannage

### Si l'erreur persiste :
1. Vérifiez les logs Render
2. Testez l'endpoint `/test` d'abord
3. Vérifiez que le modèle `.pkl` est bien uploadé
4. Assurez-vous que les colonnes du modèle correspondent à `EXPECTED_COLUMNS`

### Pour débugger :
```python
# Ajoutez ces logs dans votre modèle si nécessaire
print(f"Model feature names: {model.feature_names_in_}")
print(f"Model expects {len(model.feature_names_in_)} features")
```
