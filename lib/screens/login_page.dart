import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///Project Local Imports
import 'package:friday/widgets/login_form.dart';
import 'package:friday/widgets/onboarding_canvas_design.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    FirebaseAuth.instance.signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              child: Container(),
              painter: CanvasDesign(context: context),
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
