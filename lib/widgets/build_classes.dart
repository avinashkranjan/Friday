<<<<<<< HEAD
=======
import 'dart:collection';

import 'package:class_manager/services/user_info_services.dart';
>>>>>>> upstream/master
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:class_manager/models/classes.dart';
import 'package:table_calendar/table_calendar.dart';

<<<<<<< HEAD
Widget classesListBuilder(List<Classes> classes) {
  final DateFormat dateFormat = DateFormat("hh:mm a");
  return ListView.builder(
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
                  text: "${dateFormat.format(c.time)}", isPassed: c.isPassed),
              SizedBox(width: 20.0),
              _getTime(c, context),
              SizedBox(width: 20.0),
              _displayClassHeading(text: c.subject, isPassed: c.isPassed),
              SizedBox(width: 20.0),
              c.isHappening
                  ? Container(
                      height: 25.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(5.0),
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
                margin: EdgeInsets.only(left: 117.0, bottom: 20.0),
                width: 2,
                height: 100.0,
                color: c.isPassed ? kTextColor.withOpacity(0.3) : kTextColor,
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
                      onTap: () async {
                        await _launchURL(c.joinLink);
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
  );
}

Widget _displayClassHeading({
  @required String text,
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
  @required BuildContext context,
  @required IconData icon,
  @required String text,
  bool isPassed = true,
}) =>
    Row(
      children: <Widget>[
        Icon(
          icon,
          color: isPassed
              ? Theme.of(context).accentColor.withOpacity(0.3)
              : Theme.of(context).accentColor,
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
=======
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
>>>>>>> upstream/master
    );

<<<<<<< HEAD
_getTime(Classes c, context) {
  return Container(
    height: 25.0,
    width: 25.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: c.isPassed
            ? Theme.of(context).accentColor.withOpacity(0.3)
            : Theme.of(context).accentColor,
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
          ? Theme.of(context).accentColor.withOpacity(0.3)
          : Theme.of(context).accentColor,
      size: 15.0,
    );
  } else if (c.isHappening) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        shape: BoxShape.circle,
      ),
    );
  }
  return null;
=======
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
>>>>>>> upstream/master
}

Future<void> _launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : print('Could not launch $url');
