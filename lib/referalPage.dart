import 'package:dealsdray/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReferralPage extends StatefulWidget {
  final String userId;

  const ReferralPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  bool isLoading = false;

  Future<void> submitReferral() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String referralCode = referralCodeController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and Password are required')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // API endpoint
    const String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/email/referral';

    // Create the request body
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
      'referralCode': referralCode.isNotEmpty ? int.parse(referralCode) : null,
      'userId': widget.userId
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Referral submitted successfully')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'DealsDray'),));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Submission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: referralCodeController,
              decoration: const InputDecoration(
                labelText: 'Referral Code (Optional)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: submitReferral,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
