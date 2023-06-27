import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:friday/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

///Project Local Imports
import 'package:friday/constants.dart';
import 'package:friday/screens/login_page.dart';
import 'package:friday/services/auth_error_msg_toast.dart';
import 'package:friday/widgets/auth_input_form_field.dart';

class SignUpFormEssentialDetails extends StatefulWidget {
  @override
  _SignUpFormEssentialDetailsState createState() =>
      _SignUpFormEssentialDetailsState();
}

class _SignUpFormEssentialDetailsState
    extends State<SignUpFormEssentialDetails> {
  FToast errToast = FToast();
  String errorMsg = '';
  bool isProcessing = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _pswd = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _conpswd = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void _switchObscurity(String flag) {
    setState(() {
      if (flag == 'Password') {
        obscurePassword = !obscurePassword;
      } else {
        obscureConfirmPassword = !obscureConfirmPassword;
      }
    });
  }

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
    return Stack(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter your details...",
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.2,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  AuthInputField(
                    controller: _name,
                    labelText: "Name",
                    hintText: "Enter your name",
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

                  // Email
                  AuthInputField(
                    controller: _email,
                    labelText: "Email",
                    hintText: "Enter your email",
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

                  // Password
                  AuthInputField(
                    controller: _pswd,
                    labelText: "Password",
                    hintText: "Enter your password",
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.next,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Entypo.eye : Entypo.eye_with_line,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        _switchObscurity('Password');
                      },
                    ),
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

                  // Confirm Password
                  AuthInputField(
                    controller: _conpswd,
                    labelText: "Confirm Password",
                    hintText: "Re-enter your password",
                    obscureText: obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Entypo.eye
                            : Entypo.eye_with_line,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        _switchObscurity('Confirm Password');
                      },
                    ),
                    validator: (value) {
                      if (_conpswd.text.length < MIN_PASSWORD_LENGTH) {
                        return "Password should be more than or equal 8 characters";
                      } else if (_conpswd.text != _pswd.text) {
                        return "Passwords do not match";
                      } else if ((_conpswd.text.length >=
                              MIN_PASSWORD_LENGTH) &&
                          (_conpswd.text == _pswd.text)) {
                        return null;
                      } else
                        return "Enter a Valid password";
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  // Continue Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 13, horizontal: 20), backgroundColor: kAuthThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(30),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                       if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState!.save();
                        print(
                            "Validated: Name: ${_name.text} \n email: ${_email.text}");

                        //Close the keyboard
                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                        setState(() {
                          isProcessing = true;
                        });
                        // Authenticate user
                        errorMsg = await AuthenticationService.handleSignUp(
                            email: _email.text,
                            name: _name.text,
                            password: _pswd.text,
                            context: context,
                            );
                        setState(() {
                          isProcessing = false;
                          _formKey.currentState?.reset();
                          //show error msg
                            errorMsg != null
                              ? showErrToast(errorMsg, errToast)
                              : print("User Authenticated");
                        });
                      }
                    },
                  ),

                  // Button to go to Login Screen
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
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
        ),
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
