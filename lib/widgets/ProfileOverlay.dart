import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:class_manager/constants.dart';

class ProfileOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileOverlayState();
}

class ProfileOverlayState extends State<ProfileOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;


  @override
  void initState() {
    super.initState();


    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7),
            height: 360.0,
            decoration: ShapeDecoration(
                color: kBGColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                          height: 15,
                          width: 15,
                          child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close,
                                  size: 15, color: Colors.white))),
                    ]),
                Container(child: CircleAvatar(
                  radius: 50,  
                  backgroundImage: AssetImage(''),
                ),),
                
                Container(
                  padding: EdgeInsets.fromLTRB(5,5,5,5),
                child: Text(
                'Avinash Ranjan',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white ),
                ),
                ),                
                Container(
                  padding: EdgeInsets.fromLTRB(5,0,5,20),
                child: Text(
                'Computer Science Engineering',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white, ),textAlign: TextAlign.center 
                ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(color: Colors.red),
                      color: Colors.transparent),
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: FlatButton(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            fontSize: 15,
                            color: Colors.red),
                      ),
                    ),
                    onPressed: (){}
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}