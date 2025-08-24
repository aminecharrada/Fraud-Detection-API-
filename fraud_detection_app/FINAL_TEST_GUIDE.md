# 🧪 Guide de test final - Application Flutter + API

## ✅ Modifications apportées

### 1. **Format des données modifié**
L'application Flutter envoie maintenant les données dans le format textuel attendu par votre API :

```json
{
  "Transaction_Amount": 900000.0,
  "Transaction_Type": "Debit",           // ✅ Texte au lieu de 0.0
  "Account_Balance": 5000.0,
  "Device_Type": "Web",                  // ✅ Texte au lieu de 2.0
  "Location": "Nigeria",                 // ✅ Nom de pays au lieu de coordonnées
  "Merchant_Category": "Electronics",    // ✅ Texte au lieu de 0.0
  "Card_Type": "Visa",                   // ✅ Texte au lieu de 0.0
  "Authentication_Method": "OTP",        // ✅ Texte au lieu de 1.0
  "Is_Weekend": 1,
  "Hour": 11,
  "Month": 8,
  "Year": 2025
}
```

### 2. **Gestion de la réponse API**
L'application gère maintenant le format de réponse de votre API :
- ✅ `fraud_probability` : Probabilité de fraude
- ✅ `threshold_used` : Seuil utilisé
- ✅ `prediction` : Prédiction numérique (0 ou 1)

### 3. **Conversion automatique**
- ✅ **Coordonnées → Pays** : `40.7128, -74.0060` → `USA`
- ✅ **Types de transaction** : Conserve les valeurs textuelles
- ✅ **Appareils** : Mobile, Tablet, Web, Laptop
- ✅ **Méthodes d'auth** : PIN, OTP, Password, Biometric, None

## 🧪 Tests à effectuer

### Test 1: Transaction normale (faible risque)
1. **Lancez l'app** : `flutter run`
2. **Remplissez** :
   - Amount: `150`
   - Type: `Credit`
   - Category: `Restaurants`
   - Card: `MasterCard`
   - Auth: `PIN`
3. **Étape 2** : Vérifiez les données auto-détectées
4. **Soumettez** : Devrait montrer **Low Risk**

### Test 2: Transaction à haut risque
1. **Remplissez** :
   - Amount: `900000` (montant très élevé)
   - Type: `Debit`
   - Category: `Electronics`
   - Card: `Visa`
   - Auth: `OTP`
2. **Étape 2** : Modifiez Device Type → `Web`
3. **Soumettez** : Devrait montrer **Medium/High Risk**

### Test 3: Transaction weekend + heure tardive
1. **Remplissez** une transaction normale
2. **Étape 2** : 
   - Modifiez l'heure → `23:00` (heure tardive)
   - Vérifiez que Weekend = `Yes`
3. **Soumettez** : Risque augmenté

## 📊 Résultats attendus

### ✅ **Succès** - L'API fonctionne
- **Pas de message** "Using mock data"
- **Probabilité réelle** affichée (ex: 46.2%)
- **Seuil** affiché (ex: 50.0%)
- **Prédiction** basée sur le modèle réel

### ❌ **Échec** - Retour aux données mock
- **Message** "Using mock data - API server not available"
- **Probabilité calculée** par l'app Flutter
- **Logs d'erreur** dans la console

## 🔍 Debugging

### Vérifier les logs Flutter
```bash
# Dans la console Flutter, cherchez :
🚀 Sending request to: https://fraud-detection-api-3.onrender.com/predict
📦 Data: {"Transaction_Amount":900000.0,"Transaction_Type":"Debit"...}
📡 Response status: 200
📄 Response body: {"fraud_probability":0.4621,"prediction":0,"threshold_used":0.5}
✅ API Response processed:
   Fraud Probability: 46.2%
   Threshold: 50.0%
   Prediction: Low Risk
```

### Si l'API ne répond pas
```bash
# Testez directement l'API :
dart test_flutter_api_format.dart

# Ou avec curl :
curl -X POST https://fraud-detection-api-3.onrender.com/predict \
  -H "Content-Type: application/json" \
  -d '{"Transaction_Amount":900000.0,"Transaction_Type":"Debit","Device_Type":"Web","Location":"Nigeria"}'
```

## 🎯 Validation finale

### L'application est prête si :
1. ✅ **API répond** avec status 200
2. ✅ **Données textuelles** acceptées par l'API
3. ✅ **Probabilités réelles** affichées dans l'app
4. ✅ **Interface complète** fonctionne (3 écrans)
5. ✅ **Actions finales** marchent (Cancel, Proceed, etc.)

### Problèmes possibles :
- **API endormie** : Render met les apps en veille, première requête peut être lente
- **Format de données** : Vérifiez que l'API accepte le format textuel
- **CORS** : Problème de cross-origin (normalement résolu)

## 🚀 Déploiement production

Une fois validé :
1. **Retirez les logs** de debug (print statements)
2. **Configurez l'URL** de production
3. **Testez sur appareil** physique
4. **Validez les permissions** réseau

## 📱 Démonstration

Pour une démo impressionnante :
1. **Transaction normale** → Low Risk (vert)
2. **Gros montant** → Medium/High Risk (orange/rouge)
3. **Montrez l'édition** des champs auto-détectés
4. **Expliquez les actions** finales selon le niveau de risque

L'application est maintenant **prête pour la production** ! 🎉
