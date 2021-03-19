import 'package:class_manager/services/user_info_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:class_manager/constants.dart';
import 'package:class_manager/models/classes.dart';

class BuildClasses extends StatelessWidget {
  final DateFormat dateFormat = DateFormat("hh:mm a");

  @override
  Widget build(BuildContext context) {
    final String collegeID = Provider.of<UserInfoServices>(
      context,
      listen: false,
    ).user.collegeID;

    final classes = getClassList(collegeID);

    return FutureBuilder(
      future: classes,
      builder: (BuildContext context, AsyncSnapshot<List<Classes>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData)
          return Center(
            child: Text(
              'No classes added yet!',
              style: TextStyle(color: Colors.white),
            ),
          );

        return classesListBuilder(snapshot.data);
      },
    );
  }

  Widget classesListBuilder(List<Classes> classes) {
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
                Text(
                  "${dateFormat.format(c.time)}",
                  style: TextStyle(
                    color: c.isPassed
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(width: 20.0),
                _getTime(c, context),
                SizedBox(width: 20.0),
                Text(
                  c.subject,
                  style: TextStyle(
                    color: c.isPassed
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white,
                    fontSize: 18.0,
                  ),
                ),
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
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: c.isPassed
                              ? Theme.of(context).accentColor.withOpacity(0.3)
                              : Theme.of(context).accentColor,
                          size: 20.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          c.type,
                          style: TextStyle(
                            color: c.isPassed
                                ? kTextColor.withOpacity(0.3)
                                : kTextColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: c.isPassed
                              ? Theme.of(context).accentColor.withOpacity(0.3)
                              : Theme.of(context).accentColor,
                          size: 20.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          c.teacherName,
                          style: TextStyle(
                            color: c.isPassed
                                ? kTextColor.withOpacity(0.3)
                                : kTextColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
  }
}
