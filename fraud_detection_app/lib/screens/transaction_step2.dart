import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';
import 'risk_assessment.dart';

class TransactionStep2Screen extends StatefulWidget {
  const TransactionStep2Screen({Key? key}) : super(key: key);

  @override
  State<TransactionStep2Screen> createState() => _TransactionStep2ScreenState();
}

class _TransactionStep2ScreenState extends State<TransactionStep2Screen> {
  bool _isLoading = false;
  String _deviceType = 'Mobile';
  String _location = 'Loading...';
  DateTime _timestamp = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeAutoDetectedFields();
  }

  Future<void> _initializeAutoDetectedFields() async {
    setState(() {
      _deviceType = LocationService.getDeviceType();
      _timestamp = DateTime.now();
    });

    final location = await LocationService.getCurrentLocation();
    setState(() {
      _location = location;
    });

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.updateDeviceType(_deviceType);
    provider.updateLocation(_location);
    provider.updateTimestamp(_timestamp);
    provider.updateIpAddressFlag(0); 
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('New Transaction (2/2)'),
      backgroundColor: Colors.blue[600],
      foregroundColor: Colors.white,
    ),
    body: SafeArea(
      child: SingleChildScrollView(  
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Auto-detected Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap to edit',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            _buildEditableField('Device Type', _deviceType, () => _editDeviceType()),
            const SizedBox(height: 12),
            _buildEditableField('Location', _location, () => _editLocation()),
            const SizedBox(height: 12),
            _buildEditableField('Timestamp', _formatTimestamp(_timestamp), () => _editTimestamp()),
            const SizedBox(height: 12),
            _buildReadOnlyField('Hour', _timestamp.hour.toString()),
            const SizedBox(height: 12),
            _buildReadOnlyField('Month', _timestamp.month.toString()),
            const SizedBox(height: 12),
            _buildReadOnlyField('Year', _timestamp.year.toString()),
            const SizedBox(height: 12),
            _buildReadOnlyField('Weekend', _isWeekend(_timestamp) ? 'Yes' : 'No'),
            const SizedBox(height: 12),
            _buildReadOnlyField('IP Flag', '0'),

            const SizedBox(height: 24),

            const Text(
              'Backend-computed Fields',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Read-only (computed by server)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            _buildServerField('Daily Tx Count', '1'),
            const SizedBox(height: 12),
            _buildServerField('Avg Amount (7d)', '\$125.50'),
            const SizedBox(height: 12),
            _buildServerField('Failed Tx (7d)', '0'),
            const SizedBox(height: 12),
            _buildServerField('Card Age', '365 days'),
            const SizedBox(height: 12),
            _buildServerField('Tx Distance', '0.0 km'),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _submitTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Submit for Risk Check',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildEditableField(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue[50],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Icon(Icons.edit, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServerField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'server',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  void _editDeviceType() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Device Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Mobile', 'Tablet', 'Web', 'Laptop'].map((type) {
            return ListTile(
              title: Text(type),
              onTap: () {
                setState(() {
                  _deviceType = type;
                });
                Provider.of<TransactionProvider>(context, listen: false)
                    .updateDeviceType(type);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _editLocation() {
    final controller = TextEditingController(text: _location);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _location = controller.text;
              });
              Provider.of<TransactionProvider>(context, listen: false)
                  .updateLocation(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editTimestamp() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_timestamp),
      );

      if (time != null) {
        final newTimestamp = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        setState(() {
          _timestamp = newTimestamp;
        });

        Provider.of<TransactionProvider>(context, listen: false)
            .updateTimestamp(newTimestamp);
      }
    }
  }

  Future<void> _submitTransaction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      final result = await ApiService.submitTransaction(provider.transactionData);

      if (result['success']) {
        provider.updateRiskAssessment(
          result['fraud_probability'],
          result['threshold'],
          result['prediction'],
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RiskAssessmentScreen(isMockData: result['mock'] ?? false),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${result['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
