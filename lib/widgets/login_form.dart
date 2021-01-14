import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_icons/flutter_icons.dart';

///Project Local Imports
import 'package:class_manager/constants.dart';
import 'package:class_manager/screens/signup_page.dart';
import 'package:class_manager/services/authentication.dart';
import 'package:class_manager/services/auth_error_msg_toast.dart';
import 'package:class_manager/widgets/auth_input_form_field.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  FToast errToast;
  String errorMsg;
  bool isProcessing;
  TextEditingController _email, _pswd;
  GlobalKey<FormState> _formKey;
  @override
  void initState() {
    super.initState();
    errToast = FToast();
    errToast.init(context);
    isProcessing = false;
    _email = new TextEditingController();
    _pswd = new TextEditingController();
    _formKey = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    Widget _loginForm = Container(
      alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
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
              AuthInputField(
                controller: _email,
                labelText: "Email",
                textInputAction: TextInputAction.next,
                suffixIcon: Icon(Icons.person, color: Colors.white),
                validator: (value) {
                  RegExp _emailRegex = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (_emailRegex.hasMatch(_email.text)) {
                    return null;
                  }
                  return "Enter Valid Email";
                },
              ),
              SizedBox(
                height: 40,
              ),
              AuthInputField(
                controller: _pswd,
                labelText: "Password",
                obscureText: true,
                // helperText: "Password should be more than 8 characters",
                textInputAction: TextInputAction.done,
                suffixIcon: Icon(Entypo.key, color: Colors.white),
                validator: (value) {
                  if ((_pswd.text.length >= MIN_PASSWORD_LENGTH)) {
                    return null;
                  }
                  return "Password should be more than or equal to 8 characters";
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: null, //TODO: Implement Forgot Password Feature
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 15,
                      color: kAuthThemeColor,
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
                            vertical: 15,
                            horizontal:
                                (MediaQuery.of(context).size.width / 8) - 10),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(30)),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: kAuthThemeColor,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpPage()),
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal:
                                (MediaQuery.of(context).size.width / 8) - 10),
                        color: kAuthThemeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(30)),
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            print("Validated: ${_email.text}, ${_pswd.text}");
                            //Close the keyboard
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              isProcessing = true;
                            });
                            errorMsg = await AuthenticationService.handleLogin(
                                _email.text, _pswd.text, context);

                            print("User Logged In");
                            setState(() {
                              isProcessing = false;
                              _formKey.currentState.reset();
                              //show error msg
                              showErrToast(errorMsg, errToast);
                            });
                          }
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
    return Stack(
      children: [
        _loginForm,
        isProcessing
            ? Container(
                height: double.infinity,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()),
                color: Colors.black.withOpacity(0.3),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
