import 'package:flutter/material.dart';
import 'package:friday/services/phone_number_verification_db.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String phoneNumber;
  final PhoneNumberVerificationDb phoneNumberVerificationDb;

  VerifyCodeScreen({
    required this.phoneNumber,
    required this.phoneNumberVerificationDb,
  });
  
  get verifyCodeScreenCallback => null;

  @override
  Widget build(BuildContext context) {
    String verificationCode = '';

    void handleVerification() async {
      try {
        await phoneNumberVerificationDb.verifyCode(phoneNumber, verificationCode);
        Navigator.push(
          context,
          phoneNumberVerificationDb.verifyPhoneNumber(phoneNumber, verifyCodeScreenCallback) as Route<Object?>
        );
      } catch (e) {
        // Handle verification code submission failure
        print('Verification Code Submission Failed: ${e.toString()}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Code'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Code will be sent to $phoneNumber',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  verificationCode = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter verification code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  handleVerification();
                },
                child: Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
