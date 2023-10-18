import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumberVerificationDb {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var verificationCallback;

  PhoneNumberVerificationDb({required this.verificationCallback});

  Future<void> verifyPhoneNumber(
      String phoneNumber, verifyCodeScreenCallback) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification Failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Verification Code Sent to $phoneNumber');
        // ignore: unnecessary_statements
        (String verificationId, int? resendToken) {
          print('Verification Code Sent to $phoneNumber');
        };
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Code Auto Retrieval Timeout');
      },
    );
  }

  Future<void> verifyCode(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await _signInWithCredential(credential);
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        print('Phone Number Verified: ${user.phoneNumber}');
        // Handle phone number verification success
      } else {
        print('Phone Number Verification Failed: User is null');
        // Handle phone number verification failure
      }
    } catch (e) {
      print('Phone Number Verification Failed: ${e.toString()}');
      // Handle phone number verification failure
    }
  }
}
