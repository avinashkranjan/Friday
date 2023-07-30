import 'dart:collection';

import 'package:friday/screens/classes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:friday/models/classes.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants.dart';
import '../services/classes_db_services.dart';

class BuildClasses extends StatefulWidget {
  @override
  _BuildClassesState createState() => _BuildClassesState();
}

class _BuildClassesState extends State<BuildClasses> {
  final DateFormat dateFormat = DateFormat("hh:mm a");
  final ClassesDBServices classesDBServices = ClassesDBServices();

  List<Classes> classesList = [];

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  currClassesRealTimeDataFetch() {
    classesDBServices
        .getClassListAsStream(FirebaseAuth.instance.currentUser!.uid)
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<dynamic, dynamic> classesMap = Map<dynamic, dynamic>();
        classesMap = (documentSnapshot.data() as Map)['classes'];

        if (classesList.isNotEmpty) classesList.clear();

        if (classesMap.isNotEmpty &&
            classesMap.containsKey(_selectedDay.toString().split(" ")[0])) {
          if (mounted) {
            setState(() {
              List<dynamic> allClassesList =
              classesMap[_selectedDay.toString().split(" ")[0]];

              allClassesList.forEach((classInformation) {
                classesList.add(Classes.fromMap(classInformation));
              });
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    currClassesRealTimeDataFetch();

    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Classes>> dateClassesMap = classEvents(classesList);

    return classCalendarView(classesList, dateClassesMap);
  }

  Map<DateTime, List<Classes>> classEvents(List<Classes> classesList) {
    Map<DateTime, List<Classes>> kEventSource = {};

    classesList.forEach((element) {
      kEventSource[DateTime(
        element.time.year,
        element.time.month,
        element.time.day,
      )] = kEventSource[DateTime(
        element.time.year,
        element.time.month,
        element.time.day,
      )] !=
          null
          ? [
        ...kEventSource[DateTime(
          element.time.year,
          element.time.month,
          element.time.day,
        )]!,
        element
      ]
          : [element];
    });

    return kEventSource;
  }

  int _getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Widget classCalendarView(
      List<Classes> classes,
      Map<DateTime, List<Classes>> dateClassesMap,
      ) {
    final kEvents = LinkedHashMap<DateTime, List<Classes>>(
      equals: isSameDay,
      hashCode: _getHashCode,
    )..addAll(dateClassesMap);

    List<Classes> _getEventsForDay(DateTime day) {
      return kEvents[day] ?? [];
    }

    void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      if (!isSameDay(_selectedDay, selectedDay)) {
        setState(() {
          _selectedDay = selectedDay;
          dateController.text = _selectedDay.toString().split(" ")[0];
          currClassesRealTimeDataFetch();
          _focusedDay = focusedDay;
        });
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),color: Colors.white12,
            child:
            TableCalendar<Classes>(
              onFormatChanged: (format) {},
              firstDay: DateTime.utc(2002),
              lastDay: DateTime.utc(2024),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              onDaySelected: _onDaySelected,

              calendarStyle: CalendarStyle(
                disabledTextStyle: TextStyle(color: Colors.white),
                weekNumberTextStyle: TextStyle(color: Theme.of(context).primaryColor),
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
              ),
            ),),
          classesList != null && classesList.isNotEmpty
              ? Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 40.0,
              top: 40.0,
              bottom: 30.0,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: classes.length,
              itemBuilder: (BuildContext context, int index) {
                Classes c = classes[index];
                _getStatus(c);
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _displayClassHeading(
                            text: "${dateFormat.format(c.time)}",
                            isPassed: c.isPassed),
                        SizedBox(width: 20.0),
                        _getTime(c, context),
                        SizedBox(width: 20.0),
                        _displayClassHeading(
                            text: c.subject, isPassed: c.isPassed),
                        SizedBox(width: 20.0),
                        c.isHappening
                            ? Container(
                          height: 25.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary,
                            borderRadius:
                            BorderRadius.circular(5.0),
                          ),
                          child: Center(
                              child: Text(
                                "Now",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                          EdgeInsets.only(left: 117.0, bottom: 20.0),
                          width: 2,
                          height: 100.0,
                          color: c.isPassed
                              ? kTextColor.withOpacity(0.3)
                              : kTextColor,
                        ),
                        SizedBox(width: 28.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildClassDetail(
                              context: context,
                              icon: Icons.location_on,
                              text: c.type,
                              isPassed: c.isPassed,
                            ),
                            SizedBox(height: 6.0),
                            _buildClassDetail(
                              context: context,
                              icon: Icons.person,
                              text: c.teacherName,
                              isPassed: c.isPassed,
                            ),
                            SizedBox(height: 6.0),
                            if (!c.isPassed && c.type == 'Online')
                              InkWell(
                                onTap: () {
                                  _launchURL(c.joinLink);
                                },
                                child: _buildClassDetail(
                                  context: context,
                                  icon: Icons.phone_outlined,
                                  text: 'Join Now',
                                  isPassed: c.isPassed,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 20.0),
                  ],
                );
              },
            ),
          )
              : Center(),
        ],
      ),
    );
  }

  Widget _displayClassHeading({
    required String text,
    bool isPassed = true,
  }) =>
      Text(
        text,
        style: TextStyle(
          color: isPassed ? Colors.white.withOpacity(0.2) : Colors.white,
          fontSize: 18.0,
        ),
      );

  _getStatus(Classes c) {
    DateTime now = DateTime.now();
    DateTime finishedTime = c.time.add(Duration(hours: 1));

    if (now.difference(c.time).inMinutes >= 59) {
      c.isPassed = true;
    } else if (now.difference(c.time).inMinutes <= 59 &&
        now.difference(finishedTime).inMinutes >= -59) {
      c.isHappening = true;
    }
  }

  Widget _buildClassDetail({
    required BuildContext context,
    required IconData icon,
    required String text,
    bool isPassed = true,
  }) =>
      Row(
        children: <Widget>[
          Icon(
            icon,
            color: isPassed
                ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                : Theme.of(context).colorScheme.secondary,
            size: 20.0,
          ),
          SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(
              color: isPassed ? kTextColor.withOpacity(0.3) : kTextColor,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );

  _getTime(Classes c, context) {
    return Container(
      height: 25.0,
      width: 25.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: c.isPassed
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
              : Theme.of(context).colorScheme.secondary,
          // width: 2.0,
        ),
      ),
      child: _getChild(c, context),
    );
  }

  _getChild(Classes c, context) {
    if (c.isPassed) {
      return Icon(
        Icons.check,
        color: c.isPassed
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
            : Theme.of(context).colorScheme.secondary,
        size: 15.0,
      );
    } else if (c.isHappening) {
      return Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
      );
    }
    return null;
  }

  void _launchURL(String url) async => await canLaunchUrl(Uri.parse(url))
      ? await launchUrl(Uri.parse(url))
      : throw 'Could not launch $url';
}
