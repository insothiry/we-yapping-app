import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:we_yapping_app/src/screens/signup/otp_screen.dart';
import 'package:we_yapping_app/src/screens/signup/signup_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  String _verificationId = '';

  void _sendOtp() {
    setState(() {
      _isOtpSent = true;
      _verificationId = '123456';
    });
  }

  void _verifyOtp() {
    if (_otpController.text == _verificationId) {
      // Proceed to next screen or show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified successfully!')),
      );
      // Navigate to next screen or perform actions on successful verification
    } else {
      // Handle incorrect OTP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BaseButton(
              text: 'Send OTP',
              onPressed: () {
                Get.to(() => const OtpScreen());
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const SignUpScreen());
                  },
                  child: const Text(
                    "Sign up here",
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
