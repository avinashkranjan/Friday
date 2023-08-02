import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/alert.dart';
import '../widgets/countdown_painter.dart';


class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final DateFormat dateFormat = DateFormat("hh:mm a");
  late SharedPreferences preferences;
  List<Alert> favlist = [];

  @override
  void initState() {
    // TODO: implement initState
    initpref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: Colors.transparent ,leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: Colors.white,),
        onPressed: (){
          Navigator.pop(context);
        },
      ),),
      backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              SizedBox(height: 30.0),
              Text(
                "Favourites",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Center(child: TextButton(onPressed: () {
                removeall();
                },
              child: Text('CLEAR ALL FAVOURITES')),),
              SizedBox(height: 30.0),
              Container(
                padding: EdgeInsets.all(35.0),
                height: MediaQuery.of(context).size.height - 123,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: favlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    Alert alert = favlist[index];
                    int hoursLeft = DateTime.now().difference(favlist[index].time).inHours;
                    hoursLeft = hoursLeft < 0 ? -hoursLeft : 0;
                    double percent = hoursLeft / 48;


                    return Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 30.0),
                          height: 130.0,
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
                          height: 130.0,
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
                                    favlist[index].title,
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
                                        "${DateTime.now().weekday == favlist[index].time.weekday ? "Today" : DateFormat.EEEE().format(favlist[index].time)}, ${dateFormat.format(favlist[index].time)}",
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _getColor(BuildContext context, double percent) {
    if (percent >= 0.4) return Theme.of(context).colorScheme.secondary;

    return kHourColor;
  }

  void initpref() async{
    preferences = await SharedPreferences.getInstance();
    var x = await preferences.getStringList('favbool')!;
    var t = x.length;
    for(var i = 0; i < t; i++) {
      if (x[i] == 'true') {
        favlist.add(recentAlerts[i]);
      }
    }
    setState(() {
      favlist;
    });
    print('yehaibe\n');
    print(favlist);

  }

  void removeall() async {
    preferences = await SharedPreferences.getInstance();
    await preferences.remove('favbool');
    favlist = [];
    setState(() {
      favlist;
    });
  }
}

