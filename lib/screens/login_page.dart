import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

///Project Local Imports
import 'package:class_manager/constants.dart';
import 'package:class_manager/screens/signup_page.dart';
import 'package:class_manager/widgets/auth_canvas.dart';
import 'package:class_manager/widgets/bottom_navigation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email, _pswd;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  UnderlineInputBorder _inputBorderStyle = UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white70,
    ),
  );
  @override
  void initState() {
    _email = new TextEditingController();
    _pswd = new TextEditingController();
    _formKey = new GlobalKey<FormState>();
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
              painter: MyPainter(context: context),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 36,
                            letterSpacing: 2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      TextFormField(
                        controller: _email,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Email",
                          focusColor: Colors.white,
                          hintStyle: kInputTextStyle,
                          labelStyle: kInputTextStyle,
                          suffixIcon: Icon(Icons.person, color: Colors.white),
                          border: _inputBorderStyle,
                          focusedBorder: _inputBorderStyle,
                          enabledBorder: _inputBorderStyle,
                          focusedErrorBorder: _inputBorderStyle,
                        ),
                        validator: (value) {
                          if (_email.text.contains('@') &&
                              _email.text.contains('.')) {
                            return null;
                          }
                          return "Enter Valid Email";
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _pswd,
                        obscureText: true,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Password",
                          focusColor: Colors.white,
                          hintStyle: kInputTextStyle,
                          labelStyle: kInputTextStyle,
                          suffixIcon: Icon(Entypo.key, color: Colors.white),
                          border: _inputBorderStyle,
                          focusedBorder: _inputBorderStyle,
                          enabledBorder: _inputBorderStyle,
                          focusedErrorBorder: _inputBorderStyle,
                        ),
                        validator: (value) {
                          if (_pswd.text.length >= MIN_PASSWORD_LENGTH) {
                            return null;
                          }
                          return "Enter Valid password";
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed:
                              null, //TODO: Implement Forgot Password Feature
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 40),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(30)),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SignUpPage()),
                                  );
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 40),
                                color: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(30)),
                                child: Text(
                                  "Log In",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    print("Validated: " +
                                        _email.text +
                                        "," +
                                        _pswd.text);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BottomNavigation()),
                                    );
                                  }
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
