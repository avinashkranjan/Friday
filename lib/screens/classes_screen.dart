import 'package:friday/models/users.dart';
import 'package:friday/services/classes_db_services.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:friday/constants.dart';
import 'package:friday/widgets/build_classes.dart';
import 'package:friday/widgets/header.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

TextEditingController dateController = TextEditingController();

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final GlobalKey<FormState> _addClassFormKey = GlobalKey<FormState>();

  Mode _mode = Mode.Offline;
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _teacherNameController = TextEditingController();
  TextEditingController _joinLinkController = TextEditingController();

  TextEditingController _timeController = TextEditingController();

  final ClassesDBServices classesDBServices = ClassesDBServices();

  @override
  void initState() {
    super.initState();
    setState(() {
      dateController.text = DateTime.now().toString().split(" ")[0];
    });
  }

  @override
  void dispose() {
    super.dispose();
    dateController.clear();
    _subjectController.clear();
    _teacherNameController.clear();
    _joinLinkController.clear();
    _timeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: floatingActionButtonCall(),
        body: ListView(
          children: [
            Header(),
            Container(
              padding: EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Column(
                children: [
                  BuildClasses(),
                ],
              ),
            ),
          ],
        ));
  }

  Widget floatingActionButtonCall() {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.0),
      child: FloatingActionButton(
        elevation: 7.0,
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
        onPressed: () {
          print("Add New Class");
          addNewClass();
        },
      ),
    );
  }

  DropdownButtonFormField<Mode> modeChoice() {
    return DropdownButtonFormField(
      validator: (currValue) {
        if (currValue == null) return "Please Select a Mode";
        return null;
      },
      items: Mode.values
          .map((selectedMode) => DropdownMenuItem<Mode>(
              value: selectedMode,
              child: Text(
                modeEnumToString(selectedMode),
                style: TextStyle(color: Colors.white),
              )))
          .toList(),
      value: null,
      onChanged: (Mode mode) {
        setState(() {
          _mode = mode;
        });
      },
      onSaved: (Mode mode) {
        setState(() {
          _mode = mode;
        });
      },
      dropdownColor: Theme.of(context).backgroundColor,
      decoration: dropdownDecoration.copyWith(
        labelText: "Mode",
      ),
    );
  }

  void addNewClass() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Align(
              alignment: Alignment.center,
              child: Text(
                "Add New Class",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            content: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
              margin: EdgeInsets.only(top: 10.0),
              child: Form(
                key: _addClassFormKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    modeChoice(),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _subjectController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      validator: (inputVal) {
                        if (inputVal.length == 0) return "Enter Subject Name";
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Subject",
                        labelStyle: TextStyle(color: Colors.white70),
                        focusColor: Colors.white70,
                        hoverColor: Colors.white70,
                        fillColor: Colors.white70,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _teacherNameController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      validator: (inputVal) {
                        if (inputVal.length == 0) return "Enter Teacher Name";
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Teacher Name',
                        labelStyle: TextStyle(color: Colors.white70),
                        focusColor: Colors.white70,
                        hoverColor: Colors.white70,
                        fillColor: Colors.white70,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: dateController,
                            enabled: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: DateTimePicker(
                            type: DateTimePickerType.time,
                            controller: this._timeController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Time',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                            ),
                            onChanged: (val) => print(val),
                            validator: (selectedTime) {
                              if (selectedTime.length == 0)
                                return "Enter a Valid Time";
                              return null;
                            },
                            onSaved: (val) => print(val),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _joinLinkController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      validator: (inputVal) {
                        if (inputVal.length == 0 && this._mode == Mode.Online)
                          return "Enter Meeting Join Link";
                        else if (inputVal.length > 0 &&
                            this._mode == Mode.Offline)
                          return "Meeting Join Link Can't Take With Offline Mode";
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Join Link",
                        labelStyle: TextStyle(color: Colors.white70),
                        focusColor: Colors.white70,
                        hoverColor: Colors.white70,
                        fillColor: Colors.white70,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () async {
                          if (_addClassFormKey.currentState.validate()) {
                            print("Proceed");

                            // Add New Class Data to Database
                            await classesDBServices.addNewClassToFireStore(
                                dateController.text,
                                this._mode,
                                _subjectController.text,
                                _teacherNameController.text,
                                _timeController.text,
                                _joinLinkController.text);

                            // Reset
                            if (mounted) {
                              setState(() {
                                dateController.clear();
                                _timeController.clear();
                                this._mode = null;
                                _subjectController.clear();
                                _teacherNameController.clear();
                                _joinLinkController.clear();
                              });

                              // Close the keyboard
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');

                              // Close the AlertDialog
                              Navigator.pop(context);
                            }
                          } else
                            print("Can't Proceed");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CalenderDateFormatAddition extends StatelessWidget {
  final DateTime dateTime;
  final int dayAdditon;
  final bool itemSelected;

  CalenderDateFormatAddition(
      {@required this.dateTime,
      @required this.dayAdditon,
      this.itemSelected = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: (dayAdditon > 0)
                  ? dateTime.add(Duration(days: dayAdditon)).day.toString() +
                      '\n'
                  : dateTime
                          .subtract(Duration(days: dayAdditon * -1))
                          .day
                          .toString() +
                      '\n',
              style: (itemSelected == true)
                  ? kCalendarDay.copyWith(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    )
                  : kCalendarDay),
          TextSpan(
            text: (itemSelected == true)
                ? (dayAdditon > 0)
                    ? DateFormat.E()
                        .format(dateTime.add(Duration(days: dayAdditon)))
                        .toString()
                    : DateFormat.E()
                        .format(
                            dateTime.subtract(Duration(days: dayAdditon * -1)))
                        .toString()
                : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
            ),
          )
        ]),
      ),
    );
  }
}
