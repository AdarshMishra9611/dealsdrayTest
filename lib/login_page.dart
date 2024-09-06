import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp_verification_page.dart'; // Import the OTP verification screen

class LoginPage extends StatefulWidget {
  final String deviceId; // Add userId field

  LoginPage({required this.deviceId}); // Constructor to accept userId

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneCtlr = TextEditingController();
  String? deviceId = '66863b1b5120b12d7e1820ee'; // Set the deviceId here

  Future<void> sendOtp(String phoneNumber) async {
    final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp');

    final Map<String, dynamic> payload = {
      "mobileNumber": phoneNumber,
      "deviceId": deviceId // Use deviceId
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('OTP sent successfully');
        final data = jsonDecode(response.body);
        final deviceId = data['data']['deviceId'];
        final userId = data['data']['userId'];
        final status = data['status'];
        print(status);
        print(userId);
        print(deviceId);

        // Navigate to OTP verification page and pass userId and deviceId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              userId:userId, // Pass userId
              deviceId: deviceId,   // Pass deviceId
            ),
          ),
        );
      } else {
        print('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneCtlr,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final phoneNumber = phoneCtlr.text;
                sendOtp(phoneNumber); // Send the OTP with the phone number
              },
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
