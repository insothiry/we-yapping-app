import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:we_yapping_app/src/screens/signup/create_account_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _currentText = '';

  // Function to verify OTP with the server
  Future<void> verifyOtp() async {
    String enteredOtp = _pinController.text;

    if (enteredOtp.length == 6) {
      // Send the OTP to the backend for verification
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/verifyOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': widget.phoneNumber,
          'otp': enteredOtp,
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        // OTP verified successfully, navigate to the next screen
        Get.offAll(() => CreateAccountScreen(phoneNumber: widget.phoneNumber));
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
          'Sign Up',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              "Step 2 out of 2",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: BaseColor.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
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
              widget.phoneNumber, // Display the phone number
              style: const TextStyle(color: BaseColor.primaryColor),
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
