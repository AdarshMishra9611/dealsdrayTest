import 'dart:convert';
import 'package:dealsdray/main.dart';
import 'package:flutter/material.dart';
import 'package:dealsdray/referalPage.dart';
import 'package:http/http.dart' as http;

class OtpVerificationScreen extends StatefulWidget {
  final String userId;
  final String deviceId;

  OtpVerificationScreen({required this.userId, required this.deviceId});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOtp(String otp) async {
    final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification');
    final Map<String, dynamic> payload = {
      "otp": otp,
      "deviceId": widget.deviceId, // Passed from previous screen
      "userId": widget.userId,     // Passed from previous screen
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
        print('OTP verification successful: ${response.body}');
        final data = jsonDecode(response.body);
        print(data);
        // Navigate to the next screen upon successful OTP verification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReferralPage(userId:widget.userId), // Pass deviceId here
          ),
        );
      } else {
        print('OTP verification failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error verifying OTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter OTP sent to your mobile'),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final otp = otpController.text;
                verifyOtp(otp); // Verify the OTP when the button is pressed
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
