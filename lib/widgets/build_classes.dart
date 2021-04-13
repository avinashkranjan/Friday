import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:class_manager/constants.dart';
import 'package:class_manager/models/classes.dart';

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
    );

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

Future<void> _launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : print('Could not launch $url');
