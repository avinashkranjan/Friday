import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

///Project Local Imports
import 'package:class_manager/constants.dart';
import 'package:class_manager/widgets/auth_canvas.dart';
import 'package:class_manager/widgets/bottom_navigation.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _email, _pswd, _name, _conpswd;
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
    _name = new TextEditingController();
    _conpswd = new TextEditingController();
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
                        height: 60,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 42,
                            letterSpacing: 2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _name,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Name",
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
                          if (_name.text.isNotEmpty) {
                            return null;
                          }
                          return "Enter a valid name.";
                        },
                      ),
                      SizedBox(
                        height: 30,
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
                        height: 30,
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
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _conpswd,
                        obscureText: true,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Confirm Password",
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
                          if (_conpswd.text.length >= MIN_PASSWORD_LENGTH) {
                            return null;
                          } else if (_conpswd.text.length !=
                              _pswd.text.length) {
                            return "Passwords do not match";
                          }
                          return "Enter Valid password";
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      RaisedButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(30)),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            print(
                                "Validated: " + _email.text + "," + _pswd.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BottomNavigation()),
                            );
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "I am already a member",
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
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
