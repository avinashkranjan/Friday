import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project Local Imports
import 'package:friday/constants.dart';
import 'package:friday/screens/login_page.dart';
import 'package:friday/screens/signup_page.dart';
import 'package:friday/widgets/onboarding_canvas_design.dart';
import 'package:friday/widgets/round_button.dart';
import 'package:friday/services/googleAuthentication.dart';
import 'package:friday/services/facebookAuthentication.dart';
import 'package:is_first_run/is_first_run.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  late bool k;
  Future<bool> isfirstrun() async{
    k = await IsFirstRun.isFirstRun();
    return k;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isfirstrun();

  }

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
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: ClipRRect(
                        child: SvgPicture.asset(
                          "assets/icons/grad_cap.svg",
                          height: 180.0,
                          width: 150.0,
                        ),
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
                    Text(
                      "Your Personal\nClassroom Assistant",
                      maxLines: 2,
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
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
                    Center(
                      child: Text(
                        "OR Connect With",
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Image.asset(
                            "assets/images/google.png",
                            width: 50.0,
                          ),
                          onTap: () {
                            print("Google Authentication");
                            var _gSignIn = GoogleAuthenticate(context);
                            _gSignIn.loginViaGoogle();
                          },
                        ),
                        GestureDetector(
                          child: Image.asset(
                            "assets/images/fbook.png",
                            width: 48.0,
                          ),
                          onTap: () {
                            print("Facebook Authentication");
                            var _fbSignIn = FacebookAuth(context);
                            _fbSignIn.logInViaFacebook();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
