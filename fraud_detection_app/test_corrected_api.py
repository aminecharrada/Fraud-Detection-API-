import requests
import json

# URL de l'API (changez selon votre déploiement)
API_URL = "http://localhost:5000"  # Pour test local
# API_URL = "https://fraud-detection-api-3.onrender.com"  # Pour Render

def test_api_endpoint(endpoint, data=None, method='GET'):
    """Test un endpoint de l'API"""
    url = f"{API_URL}{endpoint}"
    
    try:
        if method == 'GET':
            response = requests.get(url, timeout=30)
        elif method == 'POST':
            response = requests.post(
                url, 
                json=data, 
                headers={'Content-Type': 'application/json'},
                timeout=30
            )
        
        print(f"📡 {method} {endpoint}")
        print(f"   Status: {response.status_code}")
        print(f"   Response: {response.json()}")
        print()
        
        return response.status_code == 200
        
    except Exception as e:
        print(f"❌ Error testing {endpoint}: {e}")
        return False

def main():
    print("🧪 Testing Corrected Fraud Detection API")
    print("=" * 50)
    
    # Test 1: Health check
    print("1️⃣ Testing health endpoint...")
    test_api_endpoint("/health")
    
    # Test 2: Home endpoint
    print("2️⃣ Testing home endpoint...")
    test_api_endpoint("/")
    
    # Test 3: Données Flutter (numériques)
    print("3️⃣ Testing with Flutter data (numeric)...")
    flutter_data = {
        "Transaction_Amount": 900000.0,
        "Transaction_Type": 0.0,
        "Account_Balance": 5200.0,
        "Device_Type": 2.0,
        "Location": 123456.0,
        "Merchant_Category": 0.0,
        "IP_Address_Flag": 0.0,
        "Previous_Fraudulent_Activity": 0.0,
        "Daily_Transaction_Count": 1.0,
        "Avg_Transaction_Amount_7d": 125.50,
        "Failed_Transaction_Count_7d": 0.0,
        "Card_Type": 0.0,
        "Card_Age": 365.0,
        "Transaction_Distance": 0.0,
        "Authentication_Method": 1.0,
        "Is_Weekend": 1.0,
        "Hour": 11.0,
        "Month": 8.0,
        "Year": 2025.0
    }
    
    test_api_endpoint("/test", flutter_data, 'POST')
    test_api_endpoint("/predict", flutter_data, 'POST')
    
    # Test 4: Données textuelles (comme votre exemple)
    print("4️⃣ Testing with text data...")
    text_data = {
        "Transaction_Amount": 900000.0,
        "Transaction_Type": "Debit",
        "Account_Balance": 5200.0,
        "Device_Type": "Web",
        "Location": "Nigeria",
        "Merchant_Category": "Electronics",
        "IP_Address_Flag": 0,
        "Previous_Fraudulent_Activity": 0,
        "Daily_Transaction_Count": 1,
        "Avg_Transaction_Amount_7d": 125.50,
        "Failed_Transaction_Count_7d": 0,
        "Card_Type": "Visa",
        "Card_Age": 365,
        "Transaction_Distance": 0.0,
        "Authentication_Method": "OTP",
        "Is_Weekend": 1,
        "Hour": 11,
        "Month": 8,
        "Year": 2025
    }
    
    test_api_endpoint("/test", text_data, 'POST')
    test_api_endpoint("/predict", text_data, 'POST')
    
    # Test 5: Données partielles
    print("5️⃣ Testing with partial data...")
    partial_data = {
        "Transaction_Amount": 500.0,
        "Transaction_Type": "Credit",
        "Device_Type": "Mobile",
        "Location": "USA"
    }
    
    test_api_endpoint("/test", partial_data, 'POST')
    test_api_endpoint("/predict", partial_data, 'POST')
    
    print("🏁 Testing complete!")

if __name__ == "__main__":
    main()
