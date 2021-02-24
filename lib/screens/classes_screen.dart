import 'package:flutter/material.dart';
import 'package:class_manager/constants.dart';
import 'package:class_manager/widgets/build_classes.dart';
import 'package:class_manager/widgets/header.dart';
import 'package:intl/intl.dart';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final DateTime _today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Header(),
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat.MMM().format(_today).toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_today.subtract(Duration(days: 3)).day.toString(),
                      style: kCalendarDay),
                  Text(_today.subtract(Duration(days: 2)).day.toString(),
                      style: kCalendarDay),
                  Text(_today.subtract(Duration(days: 1)).day.toString(),
                      style: kCalendarDay),
                  Text(
                    _today.day.toString(),
                    style: kCalendarDay.copyWith(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(_today.add(Duration(days: 1)).day.toString(),
                      style: kCalendarDay),
                  Text(_today.add(Duration(days: 2)).day.toString(),
                      style: kCalendarDay),
                  Text(_today.add(Duration(days: 3)).day.toString(),
                      style: kCalendarDay),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 157.0, top: 3.0),
                child: Text(
                  DateFormat.E().format(_today).toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(40.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              BuildClasses(),
            ],
          ),
        ),
      ],
    );
  }
}
