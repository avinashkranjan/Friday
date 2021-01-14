import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_icons/flutter_icons.dart';

///Project Local Imports
import 'package:class_manager/constants.dart';
import 'package:class_manager/screens/login_page.dart';
import 'package:class_manager/services/authentication.dart';
import 'package:class_manager/services/auth_error_msg_toast.dart';
import 'package:class_manager/widgets/auth_input_form_field.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  FToast errToast;
  String errorMsg;
  bool isProcessing;
  TextEditingController _email, _pswd, _name, _conpswd;
  GlobalKey<FormState> _formKey;
  @override
  void initState() {
    super.initState();
    errToast = FToast();
    errToast.init(context);
    isProcessing = false;
    _email = new TextEditingController();
    _pswd = new TextEditingController();
    _name = new TextEditingController();
    _conpswd = new TextEditingController();
    _formKey = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    Widget _signUpForm = Container(
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
              AuthInputField(
                controller: _name,
                labelText: "Name",
                textInputAction: TextInputAction.next,
                suffixIcon: Icon(Icons.person, color: Colors.white),
                validator: (value) {
                  if (_name.text.isNotEmpty) {
                    return null;
                  }
                  return "Enter a valid name";
                },
              ),
              SizedBox(
                height: 30,
              ),
              AuthInputField(
                controller: _email,
                labelText: "Email",
                textInputAction: TextInputAction.next,
                suffixIcon: Icon(Icons.email, color: Colors.white),
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
                height: 30,
              ),
              AuthInputField(
                controller: _pswd,
                labelText: "Password",
                obscureText: true,
                textInputAction: TextInputAction.next,
                suffixIcon: Icon(Entypo.key, color: Colors.white),
                validator: (value) {
                  if ((_pswd.text.length >= MIN_PASSWORD_LENGTH)) {
                    return null;
                  }
                  return "Password should be more than or equal to 8 characters";
                },
              ),
              SizedBox(
                height: 30,
              ),
              AuthInputField(
                controller: _conpswd,
                labelText: "Confirm Password",
                obscureText: true,
                textInputAction: TextInputAction.done,
                suffixIcon: Icon(Entypo.key, color: Colors.white),
                validator: (value) {
                  if (_conpswd.text.length < MIN_PASSWORD_LENGTH) {
                    return "Password should be more than or equal 8 characters";
                  } else if (_conpswd.text != _pswd.text) {
                    return "Passwords do not match";
                  } else if ((_conpswd.text.length >= MIN_PASSWORD_LENGTH) &&
                      (_conpswd.text == _pswd.text)) {
                    return null;
                  } else
                    return "Enter Valid password";
                },
              ),
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                color: kAuthThemeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(30)),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print(
                        "Validated: Name: ${_name.text} \n email: ${_email.text}");

                    //Close the keyboard
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    setState(() {
                      isProcessing = true;
                    });
                    errorMsg = await AuthenticationService.handleSignUp(
                        email: _email.text,
                        name: _name.text,
                        password: _pswd.text,
                        context: context);
                    print("User Added");
                    setState(() {
                      isProcessing = false;
                      _formKey.currentState.reset();
                      //show error msg
                      showErrToast(errorMsg, errToast);
                    });
                  }
                },
              ),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    "I am already a member",
                    style: TextStyle(
                      fontSize: 15,
                      color: kAuthThemeColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
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
    return Stack(
      children: [
        _signUpForm,
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
