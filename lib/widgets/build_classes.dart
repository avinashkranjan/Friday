import 'dart:collection';

import 'package:class_manager/services/user_info_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:class_manager/models/classes.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/classes_db_services.dart';

class BuildClasses extends StatefulWidget {
  @override
  _BuildClassesState createState() => _BuildClassesState();
}

class _BuildClassesState extends State<BuildClasses> {
  final DateFormat dateFormat = DateFormat("hh:mm a");

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  List<Classes> _selectedEvents;

  Future<List<Classes>> classes;

  @override
  void initState() {
    super.initState();
    final String collegeID = Provider.of<UserInfoServices>(
      context,
      listen: false,
    ).user.university;

    classes = classesDBServices.getClassList(collegeID);

    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: classes,
      builder: (BuildContext context, AsyncSnapshot<List<Classes>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No classes added yet!',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          Map<DateTime, List<Classes>> dateClassesMap =
              classEvents(snapshot.data);

          return classCalendarView(snapshot.data, dateClassesMap);
        }
      },
    );
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
              )],
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
          _focusedDay = focusedDay;

          _selectedEvents = _getEventsForDay(selectedDay);
        });
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: [
            TableCalendar<Classes>(
              onFormatChanged: (format) {},
              firstDay: DateTime.utc(2018),
              lastDay: DateTime.utc(2022),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              onDaySelected: _onDaySelected,
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
              ),
            ),
            if (_selectedEvents != null)
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _selectedEvents.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.grey,
                    child: ListTile(
                      title: Text(
                        _selectedEvents[index].subject,
                      ),
                      subtitle: Text(
                        'by ${_selectedEvents[index].teacherName}',
                      ),
                      trailing: _selectedEvents[index].isHappening
                          ? TextButton(
                              onPressed: () =>
                                  _launchURL(_selectedEvents[index].joinLink),
                              child: Text('Join Now'),
                            )
                          : Text(
                              dateFormat.format(_selectedEvents[index].time)),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
