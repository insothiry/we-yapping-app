import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:we_yapping_app/src/screens/login/login_screen.dart';
import 'package:we_yapping_app/src/screens/signup/otp_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  String? _phoneNumber;
  String? _phoneNumber0;

  void _sentOtp() {
    if (_formKey.currentState!.validate()) {
      // Remove leading 0 before pushing to OTP screen
      String phoneNumberToSend = _phoneNumber!.startsWith('0')
          ? _phoneNumber!.substring(1) // Remove the '0' if present
          : _phoneNumber!;
      Get.to(() => OtpScreen(phoneNumber: phoneNumberToSend));
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
              "Step 1 out of 2",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: BaseColor.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Enter your phone number",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We will send you a 6-digit verification code to your mobile number to confirm your account.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntlPhoneField(
                    focusNode: focusNode,
                    initialCountryCode: 'KH',
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    languageCode: "kh",
                    onChanged: (phone) {
                      _phoneNumber = phone.completeNumber;
                      print(_phoneNumber);
                    },
                  ),
                  const SizedBox(height: 10),
                  BaseButton(
                    onPressed: _sentOtp,
                    text: 'Send OTP',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: const Text(
                    "Login here",
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
