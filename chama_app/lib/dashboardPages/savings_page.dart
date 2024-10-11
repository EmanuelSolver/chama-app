import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // You may need this for API calls

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String? _statusMessage;

  Future<void> _makeDeposit() async {
    String amount = _amountController.text;
    String mobileNumber = _mobileController.text;

    // Validate amount
    if (amount.isEmpty) {
      setState(() {
        _statusMessage = "Please enter an amount.";
      });
      return;
    }

    // Validate mobile number
    if (mobileNumber.isEmpty) {
      setState(() {
        _statusMessage = "Please enter a mobile number.";
      });
      return;
    }

    // Replace with your backend URL to initiate STK push
    final String url = 'https://your-api-url.com/api/deposit';
    
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'amount': amount,
          'mobile_number': mobileNumber, // Include the mobile number
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = "Deposit initiated. Check your phone & M-pesa PIN";
        });
      } else {
        setState(() {
          _statusMessage = "Error: ${response.body}";
        });
      }
    } catch (error) {
      setState(() {
        _statusMessage = "An error occurred: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Deposit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amount to Deposit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mobile Number',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'M-pesa No',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _makeDeposit,
              child: const Text('Deposit Now'),
            ),
            const SizedBox(height: 20),
            if (_statusMessage != null)
              Text(
                _statusMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
