import 'dart:io';

import 'package:class_manager/constants.dart';
import 'package:class_manager/models/users.dart';
import 'package:class_manager/screens/onboarding_page.dart';
import 'package:class_manager/services/authentication.dart';
import 'package:class_manager/services/facebookAuthentication.dart';
import 'package:class_manager/services/googleAuthentication.dart';
import 'package:class_manager/services/user_info_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImagePicker _imagePicker = ImagePicker();
  Reference _storageReference = FirebaseStorage.instance.ref();

  void getImage() async {
    PickedFile image = await _imagePicker.getImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    String imagePath = image.path;

    File file = File(imagePath);

    uploadPictures(file);
  }

  uploadPictures(File image) async {
    // uploads picture(s) to storage and return it's URL
    final Reference ref =
        _storageReference.child('${Path.basename(image.path)}}');

    final UploadTask uploadTask = ref.putFile(image);
    String pictureUrl;

    await uploadTask.then(
      (taskSnapshot) async {
        pictureUrl = await taskSnapshot.ref.getDownloadURL();
      },
    );

    // UploadTaskSnapshot uploadTaskSnapshot = await uploadTask.future;
    // String pictureUrl = uploadTaskSnapshot.downloadUrl.toString();

    final userInfoProvider =
        Provider.of<UserInfoServices>(context, listen: false);

    Users currentUser = userInfoProvider.user;
    currentUser.profilePictureUrl = pictureUrl;

    userInfoProvider.setUser(currentUser);

    userInfoProvider.upateProfilePictureUrl();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User userData = firebaseAuth.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Consumer<UserInfoServices>(
          builder: (context, userInfo, _) {
            Users _user;
            if (userInfo.hasData) _user = userInfo.user;
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 0.15 * MediaQuery.of(context).size.height),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 60),
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
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
                                userInfo.hasData ? _user.name : "Loading...",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[200],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          buildDetails(
                            "Email",
                            userInfo.hasData ? _user.email : "Loading...",
                          ),
                          SizedBox(height: 20),
                          buildDetails(
                            "College",
                            userInfo.hasData ? _user.university : "Loading...",
                          ),
                          SizedBox(height: 20),
                          buildDetails(
                            "Course",
                            userInfo.hasData ? _user.course : "Loading...",
                          ),
                          SizedBox(height: 20),
                          buildDetails(
                            "Deptartment/Major",
                            userInfo.hasData ? _user.department : "Loading...",
                          ),
                          SizedBox(height: 20),
                          buildDetails(
                            "Current Academic Year",
                            userInfo.hasData
                                ? _user.year.toString()
                                : "Loading...",
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildDetails(
                                "Gender",
                                userInfo.hasData
                                    ? enumToString(_user.gender)
                                    : "Loading...",
                              ),
                              SizedBox(width: 20),
                              buildDetails(
                                "Age",
                                userInfo.hasData
                                    ? _user.age.toString()
                                    : "Loading...",
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: OutlineButton(
                              onPressed: () async {
                                print("Signing out");

                                var _gAuth = GoogleAuthenticate(context);
                                bool gResponse = await _gAuth.logOut();

                                if (!gResponse) // If Account Not Log-in Via Google Auth
                                  AuthenticationService.signout(context);
                                else {
                                  var _fbAuth = FacebookAuth(context);
                                  bool fbResponse = await _fbAuth.logOut();

                                  if (!fbResponse) {
                                    // If Account Not Log-in Via Facebook Auth
                                    AuthenticationService.signout(context);
                                  } else {
                                    // For Sign Out from Google Auth or Facebook Auth, Back to the On Boarding Page
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => OnboardingPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                }
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
                  child: CircleAvatar(
                    radius: profilePictureDiameter / 2,
                    backgroundImage:
                        _user != null && _user.profilePictureUrl.isNotEmpty
                            ? NetworkImage(_user.profilePictureUrl)
                            : AssetImage("assets/images/profile_pic.jpg"),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).backgroundColor,
                  ),
                ),
                Positioned(
                  top: 0.1 * MediaQuery.of(context).size.height +
                      profilePictureDiameter -
                      35,
                  left: (MediaQuery.of(context).size.width / 2) + 25,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: profilePictureDiameter * 0.25,
                      color: Colors.white,
                    ),
                    onPressed: getImage,
                  ),
                ),
              ],
            );
          },
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
