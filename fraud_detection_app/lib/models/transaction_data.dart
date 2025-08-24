class TransactionData {
  // Step 1 fields
  double? transactionAmount;
  String? transactionType;
  String? merchantCategory;
  String? cardType;
  String? authenticationMethod;
  
  // Step 2 auto-detected fields
  String? deviceType;
  String? location;
  DateTime? timestamp;
  int? hour;
  int? month;
  int? year;
  bool? isWeekend;
  int? ipAddressFlag;
  
  // Backend computed fields (read-only)
  double? accountBalance;
  int? dailyTransactionCount;
  double? avgTransactionAmount7d;
  int? failedTransactionCount7d;
  int? cardAge;
  double? transactionDistance;
  int? previousFraudulentActivity;
  
  // Risk assessment results
  double? fraudProbability;
  double? threshold;
  String? prediction;

  TransactionData();

  Map<String, dynamic> toJson() {
    return {
      'Transaction_Amount': (transactionAmount ?? 0.0).toDouble(),
      'Transaction_Type': (_getTransactionTypeCode(transactionType)).toDouble(),
      'Account_Balance': (accountBalance ?? 5000.0).toDouble(),
      'Device_Type': (_getDeviceTypeCode(deviceType)).toDouble(),
      'Location': (_getLocationCode(location)).toDouble(),
      'Merchant_Category': (_getMerchantCategoryCode(merchantCategory)).toDouble(),
      'IP_Address_Flag': (ipAddressFlag ?? 0).toDouble(),
      'Previous_Fraudulent_Activity': (previousFraudulentActivity ?? 0).toDouble(),
      'Daily_Transaction_Count': (dailyTransactionCount ?? 1).toDouble(),
      'Avg_Transaction_Amount_7d': (avgTransactionAmount7d ?? 100.0).toDouble(),
      'Failed_Transaction_Count_7d': (failedTransactionCount7d ?? 0).toDouble(),
      'Card_Type': (_getCardTypeCode(cardType)).toDouble(),
      'Card_Age': (cardAge ?? 365).toDouble(),
      'Transaction_Distance': (transactionDistance ?? 0.0).toDouble(),
      'Authentication_Method': (_getAuthMethodCode(authenticationMethod)).toDouble(),
      'Is_Weekend': (isWeekend == true ? 1 : 0).toDouble(),
      'Hour': (hour ?? DateTime.now().hour).toDouble(),
      'Month': (month ?? DateTime.now().month).toDouble(),
      'Year': (year ?? DateTime.now().year).toDouble(),
    };
  }

  int _getTransactionTypeCode(String? type) {
    switch (type) {
      case 'Debit': return 0;
      case 'Credit': return 1;
      case 'POS': return 2;
      case 'ATM Withdrawal': return 3;
      case 'Bank Transfer': return 4;
      default: return 0;
    }
  }

  int _getDeviceTypeCode(String? type) {
    switch (type) {
      case 'Mobile': return 0;
      case 'Tablet': return 1;
      case 'Web': return 2;
      case 'Laptop': return 3;
      default: return 0;
    }
  }

  int _getLocationCode(String? location) {
    // Simplified location encoding
    return location?.hashCode.abs() ?? 0;
  }

  int _getMerchantCategoryCode(String? category) {
    switch (category) {
      case 'Electronics': return 0;
      case 'Travel': return 1;
      case 'Clothing': return 2;
      case 'Restaurants': return 3;
      case 'Grocery': return 4;
      case 'Gas Station': return 5;
      default: return 0;
    }
  }

  int _getCardTypeCode(String? type) {
    switch (type) {
      case 'Visa': return 0;
      case 'MasterCard': return 1;
      case 'Amex': return 2;
      case 'Discover': return 3;
      default: return 0;
    }
  }

  int _getAuthMethodCode(String? method) {
    switch (method) {
      case 'PIN': return 0;
      case 'OTP': return 1;
      case 'Password': return 2;
      case 'Biometric': return 3;
      case 'None': return 4;
      default: return 4;
    }
  }
}
