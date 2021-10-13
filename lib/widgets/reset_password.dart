import 'package:friday/widgets/onboarding_canvas_design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';

///Project Local Imports
import 'package:friday/constants.dart';
import 'package:friday/screens/login_page.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  bool emailValid;
  String error;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: kTextColor,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              child: Container(),
              painter: CanvasDesign(context: context),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ), // icon is 48px widget.
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).accentColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).accentColor, width: 2.0),
                        ),
                        hintText: 'Enter Registered Email',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value.trim();
                          emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_email);
                        });
                      },
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      if (!emailValid) {
                        var snackBar = SnackBar(
                          content: Text('Incorrect Email Entered'),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        bool _errorOccurred = false;
                        auth
                            .sendPasswordResetEmail(email: _email)
                            .catchError((err) {
                          _errorOccurred = true;
                          if (err.code == 'user-not-found') {
                            var snackBar = SnackBar(
                              content: Text('User does not exist!'),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }).whenComplete(() {
                          if (!_errorOccurred) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                            var snackBar = SnackBar(
                                content: Text(
                                    'Password Reset Email Sent Succesfully'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                      }
                    },
                    child: Text(
                      "Send Reset Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //SizedBox(height:100000),
          ],
        ),
      ),
    );
  }
}
