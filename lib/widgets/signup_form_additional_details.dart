import 'package:class_manager/models/users.dart';
import 'package:class_manager/services/user_info_services.dart';
import 'package:class_manager/widgets/auth_input_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'bottom_navigation.dart';

class SignUpFormAdditionalDetails extends StatefulWidget {
  @override
  _SignUpFormAdditionalDetailsState createState() =>
      _SignUpFormAdditionalDetailsState();
}

class _SignUpFormAdditionalDetailsState
    extends State<SignUpFormAdditionalDetails> {
  var currDt = DateTime.now();
  FToast errToast;
  String errorMsg;
  bool isProcessing;
  TextEditingController _college, _course, _dept, _year, _age;
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
    _age = new TextEditingController();
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
            child: Form(
              key: _formKey,
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
                    controller: _college,
                    textInputAction: TextInputAction.next,
                    validator: (_) {
                      if (_college.text.isNotEmpty) {
                        return null;
                      }
                      return "Enter valid College Name";
                    },
                    suffixIcon:
                        Icon(Icons.home_work_sharp, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  AuthInputField(
                    labelText: "Course",
                    controller: _course,
                    textInputAction: TextInputAction.next,
                    validator: (_) {
                      if (_course.text.isNotEmpty) {
                        return null;
                      }
                      return "Enter valid Course Name";
                    },
                    suffixIcon: Icon(Icons.menu_book, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  AuthInputField(
                    labelText: "Department/Major",
                    controller: _dept,
                    textInputAction: TextInputAction.next,
                    validator: (_) {
                      if (_dept.text.isNotEmpty) {
                        return null;
                      }
                      return "Enter valid Department Name";
                    },
                    suffixIcon:
                        Icon(Icons.meeting_room_rounded, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  AuthInputField(
                    labelText: "Graduation Year",
                    controller: _year,
                    textInputAction: TextInputAction.next,
                    validator: (_) {
                      int _yr = int.tryParse(_year.text);
                      if (_year.text.isNotEmpty && _yr != null && _yr <= (currDt.year+10)) {
                        return null;
                      }
                      return "Enter valid College Year";
                    },
                    suffixIcon:
                        Icon(Icons.confirmation_num, color: Colors.white),
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
                          controller: _age,
                          textInputAction: TextInputAction.next,
                          validator: (_) {
                            int _ag = int.tryParse(_age.text);
                            if (_age.text.isNotEmpty && _ag != null)
                              return null;
                            return "Enter valid age";
                          },
                          suffixIcon: Icon(Icons.person, color: Colors.white),
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
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        print("Adding User to users collection");
                        setState(() {
                          isProcessing = true;
                        });

                        //Close the keyboard
                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                        // Set Additional details to [UserInfoServices]
                        int yr = int.tryParse(_year.text);
                        int age = int.tryParse(_age.text);
                        Provider.of<UserInfoServices>(context, listen: false)
                            .setAdditionalDetailsOfUser(_course.text,
                                _dept.text, _college.text, yr, _gen, age);

                        await Provider.of<UserInfoServices>(context,
                                listen: false)
                            .addUserToDatabase();
                        print("User Details Added");

                        setState(() {
                          isProcessing = false;
                          _formKey.currentState.reset();
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => BottomNavigation()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
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
