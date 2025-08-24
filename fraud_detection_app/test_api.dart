import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🧪 Testing Fraud Detection API...');
  
  const String apiUrl = 'https://fraud-detection-api-3.onrender.com/predict';
  
  // Test different formats
  final List<Map<String, dynamic>> testFormats = [
    // Format 1: Original format
    {
      'Transaction_Amount': 100.0,
      'Transaction_Type': 0.0,
      'Account_Balance': 5000.0,
      'Device_Type': 0.0,
      'Location': 123456.0,
      'Merchant_Category': 0.0,
      'IP_Address_Flag': 0.0,
      'Previous_Fraudulent_Activity': 0.0,
      'Daily_Transaction_Count': 1.0,
      'Avg_Transaction_Amount_7d': 100.0,
      'Failed_Transaction_Count_7d': 0.0,
      'Card_Type': 0.0,
      'Card_Age': 365.0,
      'Transaction_Distance': 0.0,
      'Authentication_Method': 0.0,
      'Is_Weekend': 0.0,
      'Hour': 14.0,
      'Month': 8.0,
      'Year': 2025.0,
    },
    // Format 2: As array
    {
      'features': [100.0, 0.0, 5000.0, 0.0, 123456.0, 0.0, 0.0, 0.0, 1.0, 100.0, 0.0, 0.0, 365.0, 0.0, 0.0, 0.0, 14.0, 8.0, 2025.0]
    },
    // Format 3: Simple test
    {
      'amount': 100.0,
      'type': 0.0
    }
  ];

  // Test with the first format
  final testData = testFormats[0];

  try {
    print('🚀 Sending POST request to: $apiUrl');
    print('📦 Data: ${jsonEncode(testData)}');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(testData),
    ).timeout(const Duration(seconds: 30));

    print('📡 Response status: ${response.statusCode}');
    print('📄 Response headers: ${response.headers}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('✅ API call successful!');
      print('🎯 Fraud probability: ${result['fraud_probability']}');
      print('🎯 Threshold: ${result['threshold']}');
      print('🎯 Prediction: ${result['prediction']}');
    } else {
      print('❌ API call failed with status: ${response.statusCode}');
      print('❌ Error: ${response.body}');
    }
  } catch (e) {
    print('💥 Exception occurred: $e');
    print('💡 This could mean:');
    print('   - API server is not running');
    print('   - Network connectivity issues');
    print('   - API endpoint URL is incorrect');
    print('   - API is taking too long to respond (timeout)');
  }
}
