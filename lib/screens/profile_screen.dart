import 'dart:io';

import 'package:friday/constants.dart';
import 'package:friday/models/users.dart';
import 'package:friday/screens/onboarding_page.dart';
import 'package:friday/services/authentication.dart';
import 'package:friday/services/facebookAuthentication.dart';
import 'package:friday/services/googleAuthentication.dart';
import 'package:friday/services/user_info_services.dart';
import 'package:friday/utils/bottom_navbar_tabs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'package:friday/services/user_db_services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImagePicker _imagePicker = ImagePicker();
  Reference _storageReference = FirebaseStorage.instance.ref();
  Map<String, dynamic> currentUser = {};

  void getImage() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

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

    String pictureUrl = await uploadTask.then((taskSnapshot) async {
       return await taskSnapshot.ref.getDownloadURL();
      },
    );

    // UploadTaskSnapshot uploadTaskSnapshot = await uploadTask.future;
    // String pictureUrl = uploadTaskSnapshot.downloadUrl.toString();

    final userInfoProvider =
        Provider.of<UserInfoServices>(context, listen: false);

    User currentUser = userInfoProvider.user;
    currentUser.profilePictureUrl = pictureUrl;

    userInfoProvider.setUser(currentUser);

    userInfoProvider.upateProfilePictureUrl();
  }

  bool visibilityName = true;
  bool visibilityFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Consumer<UserInfoServices>(
          builder: (context, userInfo, _) {
            User _user;
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
                              child: Visibility(
                                visible: visibilityName,
                                child: Text(
                                  userInfo.hasData 
                                  ? currentUser['name']
                                  : "Loading...",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue[200],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          buildDetails(
                              "Email",
                              userInfo.hasData 
                              ? currentUser['email'] 
                              : "Loading...",
                              true),
                          SizedBox(height: 20),
                          buildDetails(
                              "College",
                                   userInfo.hasData 
                                   ? currentUser['university'] 
                                   : "Loading...",
                              true),
                          SizedBox(height: 20),
                          buildDetails(
                              "Course",
                              userInfo.hasData 
                              ? currentUser['course'] 
                              : "Loading...",
                              true),
                          SizedBox(height: 20),
                          buildDetails(
                              "Deptartment/Major",
                              userInfo.hasData 
                              ? currentUser['department']
                              : "Loading...",
                              true),
                          SizedBox(height: 20),
                          buildDetails(
                              "Current Academic Year",
                               userInfo.hasData
                               ? currentUser['year'].toString()
                               : "Loading...",
                              true),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildDetails(
                                  "Gender",
                                  userInfo.hasData
                                   ? enumToString(currentUser['gender'])
                                   : "Loading...",
                                  true),
                              SizedBox(width: 20),
                              Visibility(
                                visible: !visibilityFields,
                                child: buildDetails(
                                    "Age",
                                    userInfo.hasData 
                                    ? currentUser['age'].toString() 
                                    : "Loading...",
                                    visibilityName),
                              ),
                              Visibility(
                                visible: visibilityFields,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Age',
                                      style: TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 1.2,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: kAuthThemeColor,
                                                width: 3),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: kAuthThemeColor,
                                                width: 3),
                                          ),
                                        ),
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          setState(() async {
                                            if (value != '') {
                                              currentUser['age'] = int.parse(value);
                                              await UserDBServices.updateAge(
                                                  currentUser['uid'], int.parse(value));
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: OutlinedButton(
                              onPressed: () async {
                                print("Signing out");
                                await Provider.of<BottomNavigationBarProvider>(
                                        context,
                                        listen: false)
                                    .resetCurrentIndex();
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
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.red),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: StadiumBorder(),
                                primary: Colors.transparent,
                              ),
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
                    backgroundImage: currentUser != null &&
                           currentUser['profilePictureUrl'] != null && 
                           currentUser['profilePictureUrl'].isNotEmpty
                      ? NetworkImage(currentUser['profilePictureUrl'])
                      : AssetImage("assets/images/profile_pic.jpg") as ImageProvider<Object>?,
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
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.18,
                  right: MediaQuery.of(context).size.width * 0.07,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        visibilityFields = !visibilityFields;
                        visibilityName = !visibilityName;
                      });
                    },
                    icon: Icon(
                      visibilityName ? Icons.edit_outlined : Icons.check,
                      color: Colors.white,
                      size: profilePictureDiameter * 0.25,
                    ),
                  ),
                ),
                Visibility(
                  visible: visibilityFields,
                  child: Positioned(
                    top: MediaQuery.of(context).size.height * 0.26,
                    child: Container(
                      width: 200,
                      child: TextField(
                        autofocus: true,
                        enabled: true,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kAuthThemeColor, width: 3),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kAuthThemeColor, width: 3),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        onChanged: (value) {
                          setState(() async {
                            if (value != '') {
                              currentUser['name'] = value;
                              await UserDBServices.updateName(currentUser['uid'], value);
                            }
                          });
                        },
                      ),
                    ),
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

Widget buildDetails(String title, String detail, bool visible) {
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
      Visibility(
        visible: visible,
        child: Text(
          detail,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
