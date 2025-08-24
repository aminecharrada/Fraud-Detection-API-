# Fraud Detection App

Une application Flutter complète pour la détection de fraude avec 3 écrans principaux correspondant aux wireframes demandés.

## 🚀 Fonctionnalités

### Écran 1 : Nouvelle Transaction (Étape 1/2)
- **Champs d'entrée avec validation** :
  - Amount (USD) - numérique avec validation
  - Transaction Type - dropdown (Debit, Credit, POS, ATM Withdrawal, Bank Transfer)
  - Merchant Category - dropdown (Electronics, Travel, Clothing, Restaurants, Grocery, Gas Station)
  - Card Type - dropdown (Visa, MasterCard, Amex, Discover)
  - Authentication Method - dropdown (PIN, OTP, Password, Biometric, None)
- **Bouton Continue** - navigation vers l'étape 2

### Écran 2 : Nouvelle Transaction (Étape 2/2)
- **Section Auto-détectée (tap to edit)** :
  - Device Type (Mobile, Tablet, Web, Laptop) - détecté automatiquement
  - Location - coordonnées simulées (40.7128, -74.0060)
  - Timestamp - date & heure actuelle
  - Hour/Month/Year - extraits du timestamp
  - Weekend - calculé automatiquement
  - IP Flag - par défaut 0

- **Section Backend-computed (read-only)** :
  - Daily Tx Count, Avg Amount (7d), Failed Tx (7d), Card Age, Tx Distance
  - Champs gris non modifiables avec mention "server"

- **Bouton Submit for Risk Check** - envoi vers l'API de détection

### Écran 3 : Risk Assessment
- **Affichage de la probabilité de fraude** et du seuil
- **Indicateurs visuels** :
  - 🟢 Low Risk / 🟡 Medium Risk / 🔴 High Risk
  - Barre de progression colorée
  - Icônes correspondantes
- **Détails de la transaction** (résumé des champs importants)
- **Boutons d'action** :
  - Require Extra Verification
  - Cancel Transaction
  - Proceed Anyway (Admin only)

## 🛠️ Architecture Technique

### Structure des dossiers
```
lib/
├── models/
│   └── transaction_data.dart      # Modèle de données
├── providers/
│   └── transaction_provider.dart  # Gestion d'état avec Provider
├── screens/
│   ├── transaction_step1.dart     # Écran étape 1
│   ├── transaction_step2.dart     # Écran étape 2
│   └── risk_assessment.dart       # Écran d'évaluation des risques
├── services/
│   ├── api_service.dart           # Service API
│   └── location_service.dart      # Service de localisation
└── main.dart                      # Point d'entrée de l'app
```

### Technologies utilisées
- **Flutter** - Framework UI
- **Provider** - Gestion d'état
- **HTTP** - Appels API
- **Material Design** - Design system

### Gestion des données
- **Provider pattern** pour stocker les données de transaction entre les écrans
- **Encodage automatique** des données pour l'API (Transaction_Type, Device_Type, etc.)
- **Validation** des champs d'entrée
- **Données mock** quand l'API n'est pas disponible

## 🔧 Installation et utilisation

### Prérequis
- Flutter SDK installé
- Émulateur Android/iOS ou appareil physique

### Installation
```bash
cd fraud_detection_app
flutter pub get
flutter run
```

### Configuration de l'API
Dans `lib/services/api_service.dart`, modifiez l'URL du serveur :
```dart
static const String baseUrl = 'http://YOUR_SERVER_URL:5000';
```

## 🧪 Tests

Exécuter les tests :
```bash
flutter test
```

Analyser le code :
```bash
flutter analyze
```
