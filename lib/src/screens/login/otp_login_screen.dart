import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:we_yapping_app/src/screens/bottom_navigation/bottom_navigation.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const LoginOtpScreen({super.key, required this.phoneNumber});

  @override
  LoginOtpScreenState createState() => LoginOtpScreenState();
}

class LoginOtpScreenState extends State<LoginOtpScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _currentText = '';

  Future<void> verifyOtp() async {
    String enteredOtp = _pinController.text;

    if (enteredOtp.length == 6) {
      // Send the OTP to the backend for verification
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': widget.phoneNumber,
          'otp': enteredOtp,
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        // OTP verified successfully
        final responseBody = json.decode(response.body);
        final String userId = responseBody['data']['userId'];

        // Print the userId to the console
        print('Login successful! User ID: $userId');

        // Navigate to BottomNavigation screen
        Get.offAll(() => BottomNavigation(userId: userId));
      } else {
        // Handle OTP verification failure
        final responseBody = json.decode(response.body);
        Get.snackbar('Error', responseBody['message'],
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign in',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              "Enter 6-digit verification code",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please enter the verification code that was sent to  ",
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              widget.phoneNumber,
              style: TextStyle(color: BaseColor.primaryColor),
            ),
            const SizedBox(height: 10),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _pinController,
              onChanged: (value) {
                setState(() {
                  _currentText = value;
                });
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveColor: Colors.grey,
                selectedColor: BaseColor.primaryColor,
                activeColor: BaseColor.primaryColor,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            BaseButton(
              text: 'Verify',
              onPressed: verifyOtp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive any code?",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Resend code",
                    style: TextStyle(
                      color: BaseColor.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
