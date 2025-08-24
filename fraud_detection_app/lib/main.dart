import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/transaction_step1.dart';

void main() {
  runApp(const FraudDetectionApp());
}

class FraudDetectionApp extends StatelessWidget {
  const FraudDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MaterialApp(
        title: 'Fraud Detection App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const TransactionStep1Screen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}



