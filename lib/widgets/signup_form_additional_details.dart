import 'package:class_manager/models/users.dart';
import 'package:class_manager/screens/login_page.dart';
import 'package:class_manager/services/auth_error_msg_toast.dart';
import 'package:class_manager/services/classes_db_services.dart';
import 'package:class_manager/services/user_info_services.dart';
import 'package:class_manager/widgets/auth_input_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _course, _dept, _year, _age, _colName;
  Gender _gen;
  GlobalKey<FormState> _formKey;
  GlobalKey<FormState> _colFormKey;
  String _defaultCollegeName;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String _college;
  List<String> _collegeList = [];
  Future fetchColleges;

  getData() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('colleges').get();

    List<QueryDocumentSnapshot> dataList = querySnapshot.docs;

    for (QueryDocumentSnapshot data in dataList) {
      _collegeList.add(data.id);
    }
    _collegeList.add('Not in the list');
  }

  @override
  void initState() {
    super.initState();
    errToast = FToast();
    errToast.init(context);
    isProcessing = false;
    _course = new TextEditingController();
    _dept = new TextEditingController();
    _year = new TextEditingController();
    _age = new TextEditingController();
    _colName = new TextEditingController();
    _formKey = new GlobalKey<FormState>();
    _colFormKey = new GlobalKey<FormState>();

    fetchColleges = getData();
    _defaultCollegeName = null;
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
            child: FutureBuilder<Object>(
              future: fetchColleges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Form(
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

                        // College dropdown
                        collegeField(context),

                        SizedBox(height: 20),

                        // Cource textfield
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
                          suffixIcon:
                              Icon(Icons.menu_book, color: Colors.white),
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
                          suffixIcon: Icon(Icons.meeting_room_rounded,
                              color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        AuthInputField(
                          textInputType: TextInputType.number,
                          labelText: "Current Academic Year",
                          controller: _year,
                          textInputAction: TextInputAction.next,
                          validator: (_) {
                            int _yr = int.tryParse(_year.text);
                            if (_year.text.isNotEmpty &&
                                _yr != null &&
                                _yr > 0 &&
                                _yr <= 5) {
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
                                  if (_course.text.isNotEmpty) {
                                    return null;
                                  }
                                  return "Enter valid Course Name";
                                },
                                suffixIcon:
                                    Icon(Icons.menu_book, color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 50),

                        // Signup button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 20),
                            primary: kAuthThemeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(30),
                            ),
                          ),
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
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');

                              // Set Additional details to [UserInfoServices]
                              int yr = int.tryParse(_year.text);
                              int age = int.tryParse(_age.text);

                              Provider.of<UserInfoServices>(context,
                                      listen: false)
                                  .setAdditionalDetailsOfUser(_course.text,
                                      _dept.text, _college, yr, _gen, age);

                              await Provider.of<UserInfoServices>(context,
                                      listen: false)
                                  .addUserToDatabase();

                              // Adding College Data
                              classesDBServices.verifyCollegeFieldAndUpdate(
                                  _college.toUpperCase(),
                                  _course.text.toUpperCase(),
                                  _dept.text.toUpperCase());

                              setState(() {
                                isProcessing = false;
                                _formKey.currentState.reset();
                              });

                              print("User Details Added");
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginPage()),
                                (Route<dynamic> route) => false,
                              );
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        backgroundColor: Colors.black38,
                                        title: Text(
                                          "Sign-Up Complete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          "A verification link send to your registered email\nPlease verify email and then log-in",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ));
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
                // dropdownValue = 'None';
              },
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

  DropdownButtonFormField<String> collegeField(BuildContext context) {
    return DropdownButtonFormField(
      validator: (value) {
        if (value == null) {
          return 'Required';
        } else if (value == "Not in the list")
          return "New College Name Required";
        return null;
      },
      style: TextStyle(
        color: Colors.white,
      ),
      value: _defaultCollegeName,
      onChanged: (String newValue) {
        print(newValue);

        setState(() {
          _college = newValue;
        });
        if (newValue == "Not in the list") {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Enter Your College Name"),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Form(
                        key: _colFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _colName,
                              validator: (inputVal) {
                                if (inputVal.length < 3)
                                  return "Enter a valid College Name";
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "College name",
                                focusColor: Colors.blue,
                                hoverColor: Colors.blue,
                                fillColor: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                onPressed: () async {
                                  //Close the keyboard
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');

                                  if (_colFormKey.currentState.validate()) {
                                    print("Validate");

                                    if (_collegeList.contains(
                                        this._colName.text.toUpperCase())) {
                                      print("Already Data Present");
                                      showErrToast(
                                        "College Already Present",
                                        errToast,
                                      );
                                    } else {
                                      print("Entry to list");
                                      FirebaseFirestore.instance
                                          .collection('colleges')
                                          .doc(this._colName.text.toUpperCase())
                                          .set({
                                        'classes': {},
                                        'courses': {},
                                        'details': {},
                                      });

                                      setState(() {
                                        _collegeList.add(
                                            this._colName.text.toUpperCase());
                                        _collegeList.remove("Not in the list");
                                        //_college = this._colName.text.toUpperCase();

                                        _defaultCollegeName =
                                            this._colName.text.toUpperCase();
                                      });

                                      showErrToast(
                                        "College Added",
                                        errToast,
                                      );
                                      Navigator.pop(context);
                                    }
                                  } else
                                    print("Not Validate");
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
        }
      },
      onSaved: (String value) {
        setState(() {
          _college = value;
        });
      },
      dropdownColor: Theme.of(context).backgroundColor,
      decoration: dropdownDecoration.copyWith(labelText: 'College'),
      items: _collegeList.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
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
      decoration: dropdownDecoration.copyWith(
        labelText: "Gender",
      ),
    );
  }
}
