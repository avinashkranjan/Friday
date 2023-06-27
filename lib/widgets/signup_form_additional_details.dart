import 'package:friday/models/users.dart';
import 'package:friday/services/auth_error_msg_toast.dart';
import 'package:friday/services/classes_db_services.dart';
import 'package:friday/services/user_info_services.dart';
import 'package:friday/widgets/auth_input_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'bottom_navigation.dart';

class SignUpFormAdditionalDetails extends StatefulWidget {
  SignUpFormAdditionalDetails();

  @override
  _SignUpFormAdditionalDetailsState createState() =>
      _SignUpFormAdditionalDetailsState();
}

class _SignUpFormAdditionalDetailsState
    extends State<SignUpFormAdditionalDetails> {
  FToast errToast = FToast();
  String errorMsg = "";
  bool isProcessing = false;
  TextEditingController _deptName = TextEditingController();
  TextEditingController _year = TextEditingController(); 
  TextEditingController _age = TextEditingController(); 
  TextEditingController _colName = TextEditingController();
  TextEditingController _courseName = TextEditingController(); 
  Gender? _gen;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _colFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _courseFormKey = GlobalKey<FormState>(); 
  GlobalKey<FormState> _deptFormKey = GlobalKey<FormState>();
  String _defaultCollegeName = ""; 
  String _defaultCourseName = "";
  String _defaultDepartmentName = "";

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ClassesDBServices classesDBServices = ClassesDBServices();

  String _college = "", _course = "", _department = "";
  final List<String> _collegeList = [], _coursesList = [], _departmentList = [];
  late Future fetchColleges;

  getCollegeNameData() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('colleges').get();

    List<QueryDocumentSnapshot> dataList = querySnapshot.docs;

    for (QueryDocumentSnapshot data in dataList) {
      _collegeList.add(data.id);
    }
    _collegeList.add('Not in the list');
  }

  getCoursesData() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('courses').get();
    List<QueryDocumentSnapshot> dataList = querySnapshot.docs;

    for (QueryDocumentSnapshot data in dataList) {
      _coursesList.add(data.id);
    }
    _coursesList.add('Not in the list');
  }

  getDepartmentData() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('departments').get();
    List<QueryDocumentSnapshot> dataList = querySnapshot.docs;

    for (QueryDocumentSnapshot data in dataList) {
      _departmentList.add(data.id);
    }
    _departmentList.add('Not in the list');
  }

  @override
  void initState() {
    super.initState();
    errToast = FToast();
    errToast.init(context);
    isProcessing = false;

    _year = new TextEditingController();
    _age = new TextEditingController();
    _colName = new TextEditingController();
    _courseName = new TextEditingController();
    _deptName = new TextEditingController();

    _formKey = new GlobalKey<FormState>();
    _colFormKey = new GlobalKey<FormState>();
    _courseFormKey = new GlobalKey<FormState>();
    _deptFormKey = new GlobalKey<FormState>();

    fetchColleges = getCollegeNameData();

    getCoursesData();
    getDepartmentData();

    _defaultCollegeName = '';
    _defaultCourseName = '';
    _defaultDepartmentName = '';
  }

  @override
  void dispose() {
    super.dispose();
    _year.dispose();
    _age.dispose();
    _colName.dispose();
    _courseName.dispose();
    _deptName.dispose();
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
            child: FutureBuilder<void>(
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
                                "Additional Details",
                                style: TextStyle(
                                  fontSize: 35,
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

                        // Course dropdown
                        courseField(context),

                        SizedBox(height: 20),

                        // Department dropdown
                        deptField(context),

                        SizedBox(height: 20),
                        AuthInputField(
                          textInputType: TextInputType.number,
                          labelText: "Current Academic Year",
                          hintText: "Enter your current academic year",
                          controller: _year,
                          textInputAction: TextInputAction.next,
                          validator: (_) {
                            int? _yr = int.tryParse(_year.text);
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
                                textInputType: TextInputType.number,
                                labelText: "Age",
                                hintText: "Enter your age",
                                controller: _age,
                                textInputAction: TextInputAction.next,
                                validator: (age) {
                                  if (age!.isNotEmpty &&
                                      age.length == 2 &&
                                      int.parse(age) >= 16) return null;
                                  return "Enter Valid Age";
                                },
                                suffixIcon:
                                    Icon(Icons.menu_book, color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 50),

                        // SignUp button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 20), backgroundColor: kAuthThemeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(30),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              print("Adding User to users collection");

                              setState(() {
                                isProcessing = true;
                              });

                              //Close the keyboard
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');

                              // Adding College Data
                              classesDBServices.verifyCollegeFieldAndUpdate(
                                  _college.toUpperCase(),
                                  _course.toUpperCase(),
                                  _department.toUpperCase());

                              // Set Additional details to [UserInfoServices]
                              int? yr = int.tryParse(_year.text);
                              int? age = int.tryParse(_age.text);

                              Provider.of<UserInfoServices>(context,
                                      listen: false)
                                  .setAdditionalDetailsOfUser(_course,
                                      _department, _college, yr!, _gen!, age!);

                              await Provider.of<UserInfoServices>(context,
                                      listen: false)
                                  .addUserToDatabase();

                              setState(() {
                                isProcessing = false;
                                _formKey.currentState?.reset();
                              });

                              print("User Details Added");

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BottomNavigation()),
                                (Route<dynamic> route) => false,
                              );

                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        backgroundColor: Colors.black38,
                                        title: Text(
                                          "Log-in Complete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          "Enjoy This App",
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
      isExpanded: true,
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
      onChanged: (String? newValue) {
        print(newValue);

        setState(() {
          _college = newValue!;
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
                                if (inputVal!.length < 3)
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

                                  if (_colFormKey.currentState!.validate()) {
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
      onSaved: (String? value) {
        setState(() {
          _college = value ?? '';
        });
      },
      dropdownColor: Theme.of(context).colorScheme.background,
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

  DropdownButtonFormField<String> courseField(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      validator: (value) {
        if (value == null) {
          return 'Required';
        } else if (value == "Not in the list") return "New Course Required";
        return null;
      },
      style: TextStyle(
        color: Colors.white,
      ),
      value: _defaultCourseName,
      onChanged: (String? newValue) {
        print(newValue);

        setState(() {
          _course = newValue ?? '';
        });
        if (newValue == "Not in the list") {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Enter Your College Name"),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Form(
                        key: _courseFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _courseName,
                              validator: (inputVal) {
                                if (inputVal!.length < 2)
                                  return "Enter a valid Course Name";
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Course name",
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

                                  if (_courseFormKey.currentState!.validate()) {
                                    print("Validate");

                                    if (_coursesList.contains(
                                        this._courseName.text.toUpperCase())) {
                                      print("Already Data Present");
                                      showErrToast(
                                        "College Already Present",
                                        errToast,
                                      );
                                    } else {
                                      print("Entry to list");
                                      FirebaseFirestore.instance
                                          .collection('courses')
                                          .doc(this
                                              ._courseName
                                              .text
                                              .toUpperCase())
                                          .set({});

                                      setState(() {
                                        _coursesList.add(this
                                            ._courseName
                                            .text
                                            .toUpperCase());
                                        _coursesList.remove("Not in the list");
                                        //_college = this._colName.text.toUpperCase();

                                        _defaultCourseName =
                                            this._courseName.text.toUpperCase();
                                      });

                                      showErrToast(
                                        "Course Added",
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
      onSaved: (String? value) {
        setState(() {
          _course = value!;
        });
      },
      dropdownColor: Theme.of(context).colorScheme.background,
      decoration: dropdownDecoration.copyWith(labelText: 'Course'),
      items: _coursesList.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }

  DropdownButtonFormField<String> deptField(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      validator: (value) {
        if (value == null) {
          return 'Required';
        } else if (value == "Not in the list") return "New Department Required";
        return null;
      },
      style: TextStyle(
        color: Colors.white,
      ),
      value: _defaultDepartmentName,
      onChanged: (String? newValue) {
        print(newValue);

        setState(() {
          _department = newValue ?? '';
        });
        if (newValue == "Not in the list") {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Enter Your Department Name"),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Form(
                        key: _deptFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _deptName,
                              validator: (inputVal) {
                                if (inputVal!.length < 3)
                                  return "Enter a valid Department Name";
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Department Name",
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

                                  if (_deptFormKey.currentState!.validate()) {
                                    print("Validate");

                                    if (_departmentList.contains(
                                        this._deptName.text.toUpperCase())) {
                                      print("Already Data Present");
                                      showErrToast(
                                        "Department Already Present",
                                        errToast,
                                      );
                                    } else {
                                      print("Entry to list");
                                      FirebaseFirestore.instance
                                          .collection('departments')
                                          .doc(
                                              this._deptName.text.toUpperCase())
                                          .set({});

                                      setState(() {
                                        _departmentList.add(
                                            this._deptName.text.toUpperCase());
                                        _departmentList
                                            .remove("Not in the list");

                                        _defaultDepartmentName =
                                            this._deptName.text.toUpperCase();
                                      });

                                      showErrToast(
                                        "Department Added",
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
      onSaved: (String? value) {
        setState(() {
          _department = value!;
        });
      },
      dropdownColor: Theme.of(context).colorScheme.background,
      decoration: dropdownDecoration.copyWith(labelText: 'Department/Major'),
      items: _departmentList.map<DropdownMenuItem<String>>(
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
      onChanged: (Gender? gender) {
        setState(() {
          _gen = gender!;
        });
      },
      onSaved: (Gender? gender) {
        setState(() {
          _gen = gender!;
        });
      },
      dropdownColor: Theme.of(context).colorScheme.background,
      decoration: dropdownDecoration.copyWith(
        labelText: "Gender",
      ),
    );
  }
}
