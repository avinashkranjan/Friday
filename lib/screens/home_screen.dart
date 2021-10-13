import 'package:friday/models/alert.dart';
import 'package:friday/models/homework.dart';
import 'package:friday/widgets/countdown_painter.dart';
import 'package:flutter/material.dart';
import 'package:friday/constants.dart';
import 'package:friday/widgets/header.dart';
import 'package:friday/widgets/recents_alerts.dart';
import 'package:friday/widgets/recents_homeworks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback openHomeworkPage;
  HomeScreen({@required this.openHomeworkPage});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Header(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: GestureDetector(
            onTap: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
            child: TextField(
              enabled: false,
              style: TextStyle(color: kTextColor),
              cursorColor: kTextColor,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                border: InputBorder.none,
                fillColor: Theme.of(context).primaryColor,
                filled: true,
                hintText: "Search",
                hintStyle: TextStyle(color: kTextColor),
                prefixIcon: Icon(Icons.search, color: kTextColor, size: 26.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(width: 1, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        Container(
          padding: EdgeInsets.all(35.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Recent Alerts",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.0),
              RecentsAlerts(),
              Center(
                child: Text(
                  "View all",
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 15.0),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Recent Homework",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.0),
              RecentHomeworks(),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0),
                  ),
                  child: Text(
                    "View all",
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 15.0),
                  ),
                  onPressed: () => widget.openHomeworkPage(),
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ],
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: TextStyle(color: kTextColor),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for appBar
    return [
      IconButton(
        icon: Icon(Icons.clear_outlined),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    final List suggestionList = query.isEmpty
        ? recentAlerts
        : recentAlerts
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
    if (query.isEmpty) {
      return Center(
        child: Text('Search for the notes here'),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                if (suggestionList.length != 0)
                  Text(
                    "Recent Alerts",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (suggestionList.length != 0) SizedBox(height: 30.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: suggestionList.length,
                  itemBuilder: (context, index) {
                    final DateFormat dateFormat = DateFormat("hh:mm a");
                    Alert alert = suggestionList[index];
                    int hoursLeft =
                        DateTime.now().difference(alert.time).inHours;
                    hoursLeft = hoursLeft < 0 ? -hoursLeft : 0;
                    double percent = hoursLeft / 48;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 30.0),
                          height: 130.0,
                          width: 15.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
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
                                        color: Theme.of(context).accentColor,
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
                                        color: Theme.of(context).accentColor,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
              ],
            ),
            FutureBuilder<List<dynamic>>(
              future: getHomeworkList(),
              builder: (context, list) {
                DateFormat dateFormat = DateFormat("hh:mm a");

                List<dynamic> homeworkMap = list.data;
                if (!list.hasData)
                  return Center(child: CircularProgressIndicator());
                if (homeworkMap != null) {
                  if (homeworkMap.isEmpty)
                    return Center(
                      child: Text(
                        "No Homework",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  else {
                    List<Homework> recentHomeworks = [];
                    homeworkMap.forEach((element) {
                      if (element['title']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                        recentHomeworks.add(Homework(
                            title: element['title'],
                            dueTime: DateTime.parse(element['dueDate'])));
                    });
                    return Column(
                      children: [
                        if (recentHomeworks.length != 0)
                          Text(
                            "Recent Homework",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (recentHomeworks.length != 0) SizedBox(height: 30.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recentHomeworks.length,
                          itemBuilder: (BuildContext context, int index) {
                            Homework homework = recentHomeworks[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 30.0),
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 10.0, 10.0),
                                  width: MediaQuery.of(context).size.width - 70,
                                  decoration: BoxDecoration(
                                    color: kCardColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            child: Text(
                                              homework.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                AntDesign.clockcircle,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                size: 17.0,
                                              ),
                                              SizedBox(width: 10.0),
                                              Text(
                                                "${DateTime.now().weekday == homework.dueTime.weekday ? "Today" : DateFormat.EEEE().format(homework.dueTime)}, ${dateFormat.format(homework.dueTime)}",
                                                style: TextStyle(
                                                  color: kTextColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      _todoButton(homework, context),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  }
                }
                return Text('NULL');
              },
            ),
          ],
        ),
      ),
    );
  }

  _getColor(BuildContext context, double percent) {
    if (percent >= 0.4) return Theme.of(context).accentColor;

    return kHourColor;
  }

  _todoButton(Homework homework, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // setState(() {
        //   homework.isDone = !homework.isDone;
        // });
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(color: Theme.of(context).accentColor),
        ),
        primary: homework.isDone
            ? Theme.of(context).accentColor
            : Colors.transparent,
      ),
      child: homework.isDone ? Icon(Icons.check, color: Colors.white) : null,
    );
  }
}
