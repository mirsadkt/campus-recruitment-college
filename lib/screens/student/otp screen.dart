import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'tell us about yourself student.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String enteredOTP = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 150.0, left: 10),
              child: Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 100, bottom: 10.0, left: 50, right: 100),
              child: Center(
                child: Text(
                  "Enter the verification code we sent to your Mobile number",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: PinCodeTextField(
                  maxLength: 4, // You can change the OTP length as needed
                  onTextChanged: (value) {
                    setState(() {
                      enteredOTP = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate the entered OTP (you can add your validation logic)
                  if (enteredOTP == "1234") {
                    // Replace "1234" with your actual OTP
                    // Navigate to the next screen on successful verification
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Tellusstudent()), // Change 'Home' to your actual next page
                    );
                  } else {
                    // Handle invalid OTP (show an error message, resend OTP, etc.)
                    // For now, just show a snackbar message as an example
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid OTP. Please try again.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't receive code? ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Implement the logic to resend OTP here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP Resent'),
                      ),
                    );
                    // You can send a new OTP or trigger the resend OTP functionality.
                  },
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
