import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project Local Imports
import 'package:class_manager/constants.dart';
import 'package:class_manager/screens/login_page.dart';
import 'package:class_manager/screens/signup_page.dart';
import 'package:class_manager/widgets/onboarding_canvas_design.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              CustomPaint(
                child: Container(),
                painter: CanvasDesign(context: context),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.21,
                left: 100.0,
                right: 100.0,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      child: SvgPicture.asset(
                        "assets/icons/grad_cap.svg",
                        height: 180.0,
                        width: 150.0,
                      ),
                    ),
                    Text(
                      "Friday",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Your Personal Classroom Assistant",
                      maxLines: 2,
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.22,
                left: 50,
                right: 50,
                child: RoundButton(
                  text: 'Sign Up',
                  color: kAuthThemeColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignUpPage()),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.12,
                left: 50,
                right: 50,
                child: RoundButton(
                  color: Colors.white,
                  text: 'Log In',
                  textColor: kAuthThemeColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  RoundButton(
      {@required this.color,
      @required this.onPressed,
      @required this.text,
      @required this.textColor});
  final Color color;
  final String text;
  final Function onPressed;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        primary: color, //kAuthThemeColor
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(30)),
      ),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: textColor,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
