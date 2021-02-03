import 'package:flutter/material.dart';

///Project Local Imports
import 'package:class_manager/widgets/onboarding_canvas_design.dart';
import 'package:class_manager/widgets/signup_form_additional_details.dart';

class SignUpAdditionalDetails extends StatefulWidget {
  @override
  _SignUpAdditionalDetailsState createState() =>
      _SignUpAdditionalDetailsState();
}

class _SignUpAdditionalDetailsState extends State<SignUpAdditionalDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    _scaffoldKey = new GlobalKey<ScaffoldState>();
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
            SignUpFormAdditionalDetails(),
          ],
        ),
      ),
    );
  }
}
