import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'transaction_step1.dart';

class RiskAssessmentScreen extends StatelessWidget {
  final bool isMockData;

  const RiskAssessmentScreen({Key? key, this.isMockData = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactionData = provider.transactionData;
        final fraudProbability = transactionData.fraudProbability ?? 0.0;
        final threshold = transactionData.threshold ?? 0.5;
        final riskLevel = _getRiskLevel(fraudProbability, threshold);
        final riskColor = _getRiskColor(riskLevel);
        final riskIcon = _getRiskIcon(riskLevel);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Risk Assessment'),
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
  child: LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isMockData)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Using mock data - API server not available',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),

            // ✅ Risk Assessment Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(riskIcon, size: 40, color: riskColor),
                        const SizedBox(width: 12),
                        Text(
                          riskLevel,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: riskColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fraud Probability: ${(fraudProbability * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Threshold: ${(threshold * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: fraudProbability,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Transaction Details
            const Text(
              'Transaction Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow('Amount', '\$${transactionData.transactionAmount?.toStringAsFixed(2) ?? '0.00'}'),
                    _buildDetailRow('Type', transactionData.transactionType ?? 'N/A'),
                    _buildDetailRow('Category', transactionData.merchantCategory ?? 'N/A'),
                    _buildDetailRow('Card Type', transactionData.cardType ?? 'N/A'),
                    _buildDetailRow('Auth Method', transactionData.authenticationMethod ?? 'N/A'),
                    _buildDetailRow('Device', transactionData.deviceType ?? 'N/A'),
                    _buildDetailRow('Location', transactionData.location ?? 'N/A'),
                    _buildDetailRow('Timestamp', _formatTimestamp(transactionData.timestamp)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (riskLevel == 'Medium Risk' || riskLevel == 'High Risk')
                  ElevatedButton(
                    onPressed: () => _showExtraVerification(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Require Extra Verification', style: TextStyle(fontSize: 16)),
                  ),
                
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () => _cancelTransaction(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel Transaction', style: TextStyle(fontSize: 16)),
                ),
                
                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () => _proceedAnyway(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Proceed Anyway (Admin only)', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  ),
),

        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getRiskLevel(double probability, double threshold) {
    if (probability < threshold * 0.5) {
      return 'Low Risk';
    } else if (probability < threshold) {
      return 'Medium Risk';
    } else {
      return 'High Risk';
    }
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'Low Risk':
        return Colors.green;
      case 'Medium Risk':
        return Colors.orange;
      case 'High Risk':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel) {
      case 'Low Risk':
        return Icons.check_circle;
      case 'Medium Risk':
        return Icons.warning;
      case 'High Risk':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'N/A';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _showExtraVerification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Extra Verification Required'),
        content: const Text(
          'This transaction requires additional verification due to elevated risk. '
          'Please contact the customer for additional authentication.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _cancelTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Transaction'),
        content: const Text('Are you sure you want to cancel this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetAndGoHome(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _proceedAnyway(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Override'),
        content: const Text(
          'This action requires administrator privileges. '
          'The transaction will be processed despite the risk assessment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetAndGoHome(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction approved with admin override'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  void _resetAndGoHome(BuildContext context) {
    Provider.of<TransactionProvider>(context, listen: false).resetTransaction();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TransactionStep1Screen()),
      (route) => false,
    );
  }
}
