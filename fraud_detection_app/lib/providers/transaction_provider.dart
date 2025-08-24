import 'package:flutter/foundation.dart';
import '../models/transaction_data.dart';

class TransactionProvider with ChangeNotifier {
  TransactionData _transactionData = TransactionData();

  TransactionData get transactionData => _transactionData;

  void updateTransactionAmount(double amount) {
    _transactionData.transactionAmount = amount;
    notifyListeners();
  }

  void updateTransactionType(String type) {
    _transactionData.transactionType = type;
    notifyListeners();
  }

  void updateMerchantCategory(String category) {
    _transactionData.merchantCategory = category;
    notifyListeners();
  }

  void updateCardType(String cardType) {
    _transactionData.cardType = cardType;
    notifyListeners();
  }

  void updateAuthenticationMethod(String method) {
    _transactionData.authenticationMethod = method;
    notifyListeners();
  }

  void updateDeviceType(String deviceType) {
    _transactionData.deviceType = deviceType;
    notifyListeners();
  }

  void updateLocation(String location) {
    _transactionData.location = location;
    notifyListeners();
  }

  void updateTimestamp(DateTime timestamp) {
    _transactionData.timestamp = timestamp;
    _transactionData.hour = timestamp.hour;
    _transactionData.month = timestamp.month;
    _transactionData.year = timestamp.year;
    _transactionData.isWeekend = timestamp.weekday == DateTime.saturday || 
                                timestamp.weekday == DateTime.sunday;
    notifyListeners();
  }

  void updateIpAddressFlag(int flag) {
    _transactionData.ipAddressFlag = flag;
    notifyListeners();
  }

  void updateRiskAssessment(double probability, double threshold, String prediction) {
    _transactionData.fraudProbability = probability;
    _transactionData.threshold = threshold;
    _transactionData.prediction = prediction;
    notifyListeners();
  }

  void resetTransaction() {
    _transactionData = TransactionData();
    notifyListeners();
  }
}
