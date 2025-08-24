import 'dart:convert';
import 'package:http/http.dart' as http;

// Simulation de la classe TransactionData pour le test
class TransactionData {
  double? transactionAmount;
  String? transactionType;
  String? merchantCategory;
  String? cardType;
  String? authenticationMethod;
  String? deviceType;
  String? location;
  DateTime? timestamp;
  int? hour;
  int? month;
  int? year;
  bool? isWeekend;
  int? ipAddressFlag;

  TransactionData({
    this.transactionAmount,
    this.transactionType,
    this.merchantCategory,
    this.cardType,
    this.authenticationMethod,
    this.deviceType,
    this.location,
    this.timestamp,
    this.hour,
    this.month,
    this.year,
    this.isWeekend,
    this.ipAddressFlag,
  });
}

// Simulation de la méthode de conversion
Map<String, dynamic> convertToApiFormat(TransactionData transactionData) {
  return {
    'Transaction_Amount': transactionData.transactionAmount ?? 0.0,
    'Transaction_Type': transactionData.transactionType ?? 'Debit',
    'Account_Balance': 5000.0,
    'Device_Type': transactionData.deviceType ?? 'Mobile',
    'Location': getLocationName(transactionData.location),
    'Merchant_Category': transactionData.merchantCategory ?? 'Electronics',
    'IP_Address_Flag': transactionData.ipAddressFlag ?? 0,
    'Previous_Fraudulent_Activity': 0,
    'Daily_Transaction_Count': 1,
    'Avg_Transaction_Amount_7d': 125.50,
    'Failed_Transaction_Count_7d': 0,
    'Card_Type': transactionData.cardType ?? 'Visa',
    'Card_Age': 365,
    'Transaction_Distance': 0.0,
    'Authentication_Method': transactionData.authenticationMethod ?? 'PIN',
    'Is_Weekend': (transactionData.isWeekend == true) ? 1 : 0,
    'Hour': transactionData.hour ?? DateTime.now().hour,
    'Month': transactionData.month ?? DateTime.now().month,
    'Year': transactionData.year ?? DateTime.now().year,
  };
}

String getLocationName(String? location) {
  if (location == null) return 'Unknown';
  
  if (location.contains('40.7128, -74.0060')) return 'USA';
  if (location.contains('Nigeria') || location.contains('6.5244, 3.3792')) return 'Nigeria';
  if (location.contains('UK') || location.contains('51.5074, -0.1278')) return 'UK';
  if (location.contains('France') || location.contains('48.8566, 2.3522')) return 'France';
  if (location.contains('Germany') || location.contains('52.5200, 13.4050')) return 'Germany';
  if (location.contains('Canada') || location.contains('45.4215, -75.6972')) return 'Canada';
  
  return 'Unknown';
}

Future<void> testApiFormat() async {
  print('🧪 Testing Flutter API Format Conversion');
  print('=' * 50);

  // Test 1: Transaction normale
  print('\n1️⃣ Testing normal transaction...');
  final transaction1 = TransactionData(
    transactionAmount: 150.0,
    transactionType: 'Credit',
    merchantCategory: 'Restaurants',
    cardType: 'MasterCard',
    authenticationMethod: 'PIN',
    deviceType: 'Mobile',
    location: '40.7128, -74.0060', // New York
    hour: 14,
    month: 8,
    year: 2025,
    isWeekend: false,
    ipAddressFlag: 0,
  );

  final apiData1 = convertToApiFormat(transaction1);
  print('📦 Converted data:');
  print(jsonEncode(apiData1));

  // Test 2: Transaction à haut risque
  print('\n2️⃣ Testing high-risk transaction...');
  final transaction2 = TransactionData(
    transactionAmount: 900000.0,
    transactionType: 'Debit',
    merchantCategory: 'Electronics',
    cardType: 'Visa',
    authenticationMethod: 'OTP',
    deviceType: 'Web',
    location: 'Nigeria',
    hour: 11,
    month: 8,
    year: 2025,
    isWeekend: true,
    ipAddressFlag: 0,
  );

  final apiData2 = convertToApiFormat(transaction2);
  print('📦 Converted data:');
  print(jsonEncode(apiData2));

  // Test 3: Envoi à l'API réelle
  print('\n3️⃣ Testing API call...');
  try {
    const apiUrl = 'https://fraud-detection-api-3.onrender.com/predict';
    
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Flutter-Test/1.0',
      },
      body: jsonEncode(apiData2),
    ).timeout(const Duration(seconds: 30));

    print('📡 Response status: ${response.statusCode}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('✅ API call successful!');
      print('🎯 Fraud probability: ${result['fraud_probability']}');
      print('🎯 Prediction: ${result['prediction']}');
    } else {
      print('❌ API call failed');
    }
  } catch (e) {
    print('💥 Error calling API: $e');
  }

  print('\n' + '=' * 50);
  print('🏁 Test complete!');
}

void main() async {
  await testApiFormat();
}
