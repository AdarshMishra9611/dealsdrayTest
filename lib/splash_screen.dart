import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart'; // Assuming you have the LoginPage in this file

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    makeApiCall().then((deviceId) {
      if (deviceId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(deviceId: deviceId), // Pass deviceId here
          ),
        );
      } else {
        // Handle the error scenario (optional)
        print('Failed to retrieve deviceId');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red, // Set the background color to red
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'DealsDray', // Your text here
                style: TextStyle(
                  color: Colors.white, // Set text color to white for better contrast
                  fontSize: 24.0, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0), // Add some space between the text and the indicator
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> makeApiCall() async {
  final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add');
  final Map<String, dynamic> payload = {
    "deviceType": "android",
    "deviceId": "C6179909526098",
    "deviceName": "Samsung-MT200",
    "deviceOSVersion": "2.3.6",
    "deviceIPAddress": "11.433.445.66",
    "lat": 9.9312,
    "long": 76.2673,
    "buyer_gcmid": "",
    "buyer_pemid": "",
    "app": {
      "version": "1.20.5",
      "installTimeStamp": "2022-02-10T12:33:30.696Z",
      "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
      "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
    }
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
      final data = jsonDecode(response.body);
      final deviceId = data['data']['deviceId'];
      print('API call successful: $deviceId');
      return deviceId; // Return deviceId
    } else {
      print('API call failed: ${response.statusCode}');
      return null; // Return null if failed
    }
  } catch (e) {
    print('Error making API call: $e');
    return null;
  }
}
