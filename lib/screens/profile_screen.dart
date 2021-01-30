import 'package:class_manager/constants.dart';
import 'package:class_manager/services/authentication.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 0.15 * MediaQuery.of(context).size.height),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: (profilePictureDiameter / 2) + 5),
                      Center(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Adarsh Srivastava",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue[200],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      buildDetails("Email", "adarsh@gmail.com"),
                      SizedBox(height: 20),
                      buildDetails("College", "Stanford University"),
                      SizedBox(height: 20),
                      buildDetails("Course", "Bachelor of Technology"),
                      SizedBox(height: 20),
                      buildDetails("Year/Class", "3rd/CSE"),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildDetails("Gender", "Male"),
                          SizedBox(width: 20),
                          buildDetails("Age", "21"),
                          SizedBox(width: 20),
                        ],
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: OutlineButton(
                          onPressed: () {
                            print("Signing out");
                            AuthenticationService.signout(context);
                          },
                          borderSide: BorderSide(color: Colors.red),
                          highlightElevation: 1,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: StadiumBorder(),
                          color: Colors.transparent,
                          hoverColor: Theme.of(context).primaryColor,
                          splashColor: Theme.of(context).primaryColor,
                          focusColor: Theme.of(context).primaryColor,
                          highlightColor: Theme.of(context).primaryColor,
                          child: Text(
                            "Log out",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0.1 * MediaQuery.of(context).size.height,
              child: Container(
                height: profilePictureDiameter,
                width: profilePictureDiameter,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(profilePictureDiameter),
                  image: DecorationImage(
                    image: AssetImage("assets/images/profile_pic.jpg"),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                      color: Theme.of(context).backgroundColor, width: 3),
                ),
              ),
            ),
            Positioned(
              top: 0.1 * MediaQuery.of(context).size.height +
                  profilePictureDiameter -
                  35,
              left: (MediaQuery.of(context).size.width / 2) + 25,
              child: Icon(
                Icons.camera_alt,
                size: profilePictureDiameter * 0.25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildDetails(String title, String detail) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          letterSpacing: 1.2,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Text(
        detail,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ],
  );
}
