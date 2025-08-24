import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('🔍 Network Diagnostic Test');
  print('=' * 50);
  
  const String apiUrl = 'https://fraud-detection-api-3.onrender.com/predict';
  
  // Test 1: Basic connectivity
  print('\n1️⃣ Testing basic connectivity...');
  try {
    final uri = Uri.parse(apiUrl);
    print('   Host: ${uri.host}');
    print('   Port: ${uri.port}');
    print('   Scheme: ${uri.scheme}');
    
    // Test DNS resolution
    final addresses = await InternetAddress.lookup(uri.host);
    print('   DNS resolved to: ${addresses.map((addr) => addr.address).join(', ')}');
  } catch (e) {
    print('   ❌ DNS/Connectivity error: $e');
  }
  
  // Test 2: Simple HTTP GET
  print('\n2️⃣ Testing HTTP GET to base URL...');
  try {
    final response = await http.get(
      Uri.parse('https://fraud-detection-api-3.onrender.com'),
      headers: {'User-Agent': 'Flutter-Test/1.0'},
    ).timeout(const Duration(seconds: 10));
    print('   Status: ${response.statusCode}');
    print('   Headers: ${response.headers}');
  } catch (e) {
    print('   ❌ GET error: $e');
  }
  
  // Test 3: POST request with data
  print('\n3️⃣ Testing POST request...');
  
  final testData = {
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
  };
  
  try {
    print('   Sending POST to: $apiUrl');
    print('   Data size: ${jsonEncode(testData).length} bytes');
    
    final client = http.Client();
    final response = await client.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Flutter-NetworkTest/1.0',
      },
      body: jsonEncode(testData),
    ).timeout(const Duration(seconds: 30));
    
    print('   ✅ Response received!');
    print('   Status: ${response.statusCode}');
    print('   Content-Type: ${response.headers['content-type']}');
    print('   Body length: ${response.body.length}');
    print('   Body: ${response.body}');
    
    client.close();
    
  } catch (e) {
    print('   ❌ POST error: $e');
    print('   Error type: ${e.runtimeType}');
    
    if (e.toString().contains('Failed to fetch')) {
      print('   💡 This is a network connectivity issue');
      print('   💡 Possible causes:');
      print('      - No internet connection');
      print('      - Firewall blocking the request');
      print('      - Proxy configuration issues');
      print('      - DNS resolution problems');
    }
  }
  
  // Test 4: Alternative HTTP client
  print('\n4️⃣ Testing with HttpClient...');
  try {
    final httpClient = HttpClient();
    httpClient.connectionTimeout = const Duration(seconds: 10);
    
    final request = await httpClient.postUrl(Uri.parse(apiUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('User-Agent', 'Flutter-HttpClient/1.0');
    request.write(jsonEncode(testData));
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('   ✅ HttpClient response received!');
    print('   Status: ${response.statusCode}');
    print('   Body: $responseBody');
    
    httpClient.close();
    
  } catch (e) {
    print('   ❌ HttpClient error: $e');
  }
  
  print('\n' + '=' * 50);
  print('🏁 Network diagnostic complete');
}
