import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

///Project Local Imports
import 'package:class_manager/constants.dart';
import 'package:class_manager/screens/login_page.dart';
import 'package:class_manager/services/authentication.dart';
import 'package:class_manager/widgets/auth_input_form_field.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String errorMsg;
  TextEditingController _email, _pswd, _name, _conpswd;
  GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _email = new TextEditingController();
    _pswd = new TextEditingController();
    _name = new TextEditingController();
    _conpswd = new TextEditingController();
    _formKey = new GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  if (_email.text.contains('@') && _email.text.contains('.')) {
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
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(30)),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print(
                        "Validated: Name: ${_name.text} \n email: ${_email.text}");
                    errorMsg = await AuthenticationService.handleSignUp(
                        email: _email.text,
                        name: _name.text,
                        password: _pswd.text,
                        context: context);

                    print("User Added");
                    _formKey.currentState.reset();
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
                      color: Theme.of(context).accentColor,
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
  }
}
