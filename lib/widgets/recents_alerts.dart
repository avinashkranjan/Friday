import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:friday/constants.dart';
import 'package:friday/models/alert.dart';
import 'dart:convert';
import 'package:friday/widgets/countdown_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

class RecentsAlerts extends StatefulWidget {
  @override
  State<RecentsAlerts> createState() => _RecentsAlertsState();
}

class _RecentsAlertsState extends State<RecentsAlerts> with WidgetsBindingObserver {
  final DateFormat dateFormat = DateFormat("hh:mm a");
  late List<String> impstuff;
  late SharedPreferences preferences;
  @override
  void initState() {
    // TODO: implement initState
    loadpref();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('chaltorahbeh');

    loadpref();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recentAlerts.length,
      itemBuilder: (BuildContext context, int index) {
        Alert alert = recentAlerts[index];
        int hoursLeft = DateTime.now().difference(alert.time).inHours;
        hoursLeft = hoursLeft < 0 ? -hoursLeft : 0;
        double percent = hoursLeft / 48;


        return Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              height: 160.0,
              width: 15.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              height: 160.0,
              width: MediaQuery.of(context).size.width - 85,
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        alert.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            AntDesign.clockcircle,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 17.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "${DateTime.now().weekday == alert.time.weekday ? "Today" : DateFormat.EEEE().format(alert.time)}, ${dateFormat.format(alert.time)}",
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 15.0,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.receipt,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 17.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            alert.subject,
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            AntDesign.checkcircle,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 17.0,
                          ),
                          SizedBox(width: 10,),
                          Text('Mark as Important :', style: TextStyle(color: kTextColor),),
                          Checkbox(value: impstuff[index]=='false'?false:true, onChanged: (s) async {
                            impstuff[index] = s.toString();
                            await preferences.setStringList('favbool', impstuff).then((value) => print(impstuff));
                            
                            setState(() {
                              impstuff;
                            });

                          })
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    right: 0.0,
                    child: CustomPaint(
                      foregroundPainter: CountdownPainter(
                        bgColor: kBGColor,
                        lineColor: _getColor(context, percent),
                        percent: percent,
                        width: 4.0,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "$hoursLeft",
                              style: TextStyle(
                                color: _getColor(context, percent),
                                fontSize: 26.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "hours left",
                              style: TextStyle(
                                color: _getColor(context, percent),
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _getColor(BuildContext context, double percent) {
    if (percent >= 0.4) return Theme.of(context).colorScheme.secondary;

    return kHourColor;
  }

  void loadpref() async{
    preferences = await SharedPreferences.getInstance();
    impstuff = await preferences.getStringList('favbool')!;
    setState(() {
      impstuff;
    });

  }
}
