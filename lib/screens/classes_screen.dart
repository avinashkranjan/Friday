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
  int _calenderItemIndex = 0;
  _setCalenderIndex({@required int index}) {
    setState(() {
      _calenderItemIndex = index;
      print(_calenderItemIndex);
    });
  }

  @override
  void initState() {
    _calenderItemIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    _calenderItemIndex = 0;
    super.dispose();
  }

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
                  InkWell(
                    onTap: () => _setCalenderIndex(index: -3),
                    child: CalenderDateFormatAddition(
                      dateTime: _today,
                      dayAdditon: -3,
                      itemSelected: (_calenderItemIndex == -3) ? true : false,
                    ),
                  ),
                  InkWell(
                    onTap: () => _setCalenderIndex(index: -2),
                    child: CalenderDateFormatAddition(
                      dateTime: _today,
                      dayAdditon: -2,
                      itemSelected: (_calenderItemIndex == -2) ? true : false,
                    ),
                  ),
                  InkWell(
                    onTap: () => _setCalenderIndex(index: -1),
                    child: CalenderDateFormatAddition(
                      dateTime: _today,
                      dayAdditon: -1,
                      itemSelected: (_calenderItemIndex == -1) ? true : false,
                    ),
                  ),
                  InkWell(
                    onTap: () => _setCalenderIndex(index: 0),
                    child: CalenderDateFormatAddition(
                      dateTime: _today,
                      dayAdditon: 0,
                      itemSelected: (_calenderItemIndex == 0) ? true : false,
                    ),
                  ),
                  InkWell(
                      onTap: () => _setCalenderIndex(index: 1),
                      child: CalenderDateFormatAddition(
                        dateTime: _today,
                        dayAdditon: 1,
                        itemSelected: (_calenderItemIndex == 1) ? true : false,
                      )),
                  InkWell(
                      onTap: () => _setCalenderIndex(index: 2),
                      child: CalenderDateFormatAddition(
                        dateTime: _today,
                        dayAdditon: 2,
                        itemSelected: (_calenderItemIndex == 2) ? true : false,
                      )),
                  InkWell(
                      onTap: () => _setCalenderIndex(index: 3),
                      child: CalenderDateFormatAddition(
                        dateTime: _today,
                        dayAdditon: 3,
                        itemSelected: (_calenderItemIndex == 3) ? true : false,
                      )),
                ],
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
