import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'transaction_step2.dart';

class TransactionStep1Screen extends StatefulWidget {
  const TransactionStep1Screen({Key? key}) : super(key: key);

  @override
  State<TransactionStep1Screen> createState() => _TransactionStep1ScreenState();
}

class _TransactionStep1ScreenState extends State<TransactionStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  final List<String> _transactionTypes = [
    'Debit',
    'Credit',
    'POS',
    'ATM Withdrawal',
    'Bank Transfer',
  ];

  final List<String> _merchantCategories = [
    'Electronics',
    'Travel',
    'Clothing',
    'Restaurants',
    'Grocery',
    'Gas Station',
  ];

  final List<String> _cardTypes = [
    'Visa',
    'MasterCard',
    'Amex',
    'Discover',
  ];

  final List<String> _authMethods = [
    'PIN',
    'OTP',
    'Password',
    'Biometric',
    'None',
  ];

  String? _selectedTransactionType;
  String? _selectedMerchantCategory;
  String? _selectedCardType;
  String? _selectedAuthMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction (1/2)'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Amount field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (USD)',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Transaction Type dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedTransactionType,
                items: _transactionTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTransactionType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a transaction type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Merchant Category dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Merchant Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMerchantCategory,
                items: _merchantCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMerchantCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a merchant category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Card Type dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Card Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCardType,
                items: _cardTypes.map((String cardType) {
                  return DropdownMenuItem<String>(
                    value: cardType,
                    child: Text(cardType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCardType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a card type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Authentication Method dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Authentication Method',
                  border: OutlineInputBorder(),
                ),
                value: _selectedAuthMethod,
                items: _authMethods.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAuthMethod = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an authentication method';
                  }
                  return null;
                },
              ),
              const Spacer(),

              // Continue button
              ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      
      // Update transaction data
      provider.updateTransactionAmount(double.parse(_amountController.text));
      provider.updateTransactionType(_selectedTransactionType!);
      provider.updateMerchantCategory(_selectedMerchantCategory!);
      provider.updateCardType(_selectedCardType!);
      provider.updateAuthenticationMethod(_selectedAuthMethod!);

      // Navigate to step 2
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TransactionStep2Screen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
