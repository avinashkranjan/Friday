import 'package:class_manager/widgets/onboarding_canvas_design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project Local Imports
import 'package:class_manager/constants.dart';
import 'package:class_manager/screens/login_page.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
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
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).accentColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).accentColor, width: 2.0),
                        ),
                        hintText: 'Email',
                        hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value.trim();
                        });
                      },
                    ),
                  ),
                ),
                Center(
                        
              child: ElevatedButton(
             
                style: ElevatedButton.styleFrom(shape: StadiumBorder(),primary:Theme.of(context).accentColor, ),
                onPressed: () {
                  auth.sendPasswordResetEmail(email: _email);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                  var snackBar = SnackBar(content: Text('Password Reset Email Sent Succesfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
