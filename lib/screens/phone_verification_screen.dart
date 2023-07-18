import 'package:flutter/material.dart';
import 'package:friday/screens/verify_code_screen.dart';
import 'package:friday/services/phone_number_verification_db.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  PhoneNumberVerificationDb _phoneNumberVerificationDb = PhoneNumberVerificationDb(verificationCallback: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mobile Number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter your mobile number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String phoneNumber = _phoneNumberController.text;

                  // Verify phone number and send OTP
                  await _phoneNumberVerificationDb.verifyPhoneNumber(phoneNumber, null);

                  // Navigate to the Verify Code screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyCodeScreen(
                        phoneNumber: phoneNumber,
                        phoneNumberVerificationDb: _phoneNumberVerificationDb,
                      ),
                    ),
                  );
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
