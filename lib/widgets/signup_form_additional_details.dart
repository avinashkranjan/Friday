import 'package:class_manager/models/users.dart';
import 'package:class_manager/services/auth_error_msg_toast.dart';
import 'package:class_manager/services/user_info_services.dart';
import 'package:class_manager/widgets/auth_input_form_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class SignUpFormAdditionalDetails extends StatefulWidget {
  @override
  _SignUpFormAdditionalDetailsState createState() =>
      _SignUpFormAdditionalDetailsState();
}

class _SignUpFormAdditionalDetailsState
    extends State<SignUpFormAdditionalDetails> {
  FToast errToast;
  String errorMsg;
  bool isProcessing;
  TextEditingController _college, _course, _dept, _year;
  Gender _gen;
  GlobalKey<FormState> _formKey;
  UnderlineInputBorder _inputBorderStyle = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white70,
    ),
  );
  @override
  void initState() {
    super.initState();
    errToast = FToast();
    errToast.init(context);
    isProcessing = false;
    _college = new TextEditingController();
    _course = new TextEditingController();
    _dept = new TextEditingController();
    _year = new TextEditingController();
    _formKey = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        "Let's know you more...",
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
                  labelText: "College",
                  controller: null,
                  textInputAction: TextInputAction.next,
                  validator: null,
                  suffixIcon: null,
                ),
                SizedBox(height: 20),
                AuthInputField(
                  labelText: "Course",
                  controller: null,
                  textInputAction: TextInputAction.next,
                  validator: null,
                  suffixIcon: null,
                ),
                SizedBox(height: 20),
                AuthInputField(
                  labelText: "Department/Major",
                  controller: null,
                  textInputAction: TextInputAction.next,
                  validator: null,
                  suffixIcon: null,
                ),
                SizedBox(height: 20),
                AuthInputField(
                  labelText: "Year",
                  controller: null,
                  textInputAction: TextInputAction.next,
                  validator: null,
                  suffixIcon: null,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: genderField(context),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: AuthInputField(
                        labelText: "Age",
                        controller: null,
                        textInputAction: TextInputAction.next,
                        validator: null,
                        suffixIcon: null,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 50),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
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
                  onPressed: () {
                    setState(() {
                      isProcessing = true;
                    });
                    // Set Additional details to [UserInfoServices]
                    // Provider.of<UserInfoServices>(context,
                    //         listen: false)
                    //     .setAdditionalDetailsOfUser(_course, _dept, _college, _year, _gender, _age)();
                    print("User Details Added");
                    setState(() {
                      isProcessing = false;
                      _formKey.currentState.reset();
                      //show error msg
                      showErrToast(errorMsg, errToast);
                    });
                  },
                ),
              ],
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

  DropdownButtonFormField<Gender> genderField(BuildContext context) {
    return DropdownButtonFormField(
                      items: Gender.values
                          .map((e) => DropdownMenuItem<Gender>(
                              value: e,
                              child: Text(
                                enumToString(e),
                                style: TextStyle(color: Colors.white),
                              )))
                          .toList(),
                      value: null,
                      onChanged: (Gender gender) {
                        setState(() {
                          _gen = gender;
                        });
                      },
                      onSaved: (Gender gender) {
                        setState(() {
                          _gen = gender;
                        });
                      },
                      dropdownColor: Theme.of(context).backgroundColor,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Gender",
                        border: _inputBorderStyle,
                        focusedBorder: _inputBorderStyle,
                        enabledBorder: _inputBorderStyle,
                        focusedErrorBorder: _inputBorderStyle,
                        focusColor: Colors.white,
                        hintStyle: kInputTextStyle,
                        labelStyle: kInputTextStyle,
                      ),
                    );
  }
}
