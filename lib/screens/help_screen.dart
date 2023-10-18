import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../services/user_info_services.dart';
import 'app_info_screen.dart';
import 'contact_us_screen.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Consumer<UserInfoServices>(
          builder: (context, userInfo, _) {
            // ignore: unused_local_variable
            Users _user;
            if (userInfo.hasData) _user = userInfo.user!;
            return Stack(alignment: Alignment.center, children: [
              Column(children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Help Section",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.12 * MediaQuery.of(context).size.height),
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.contact_mail,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Contact Us',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactUsScreen(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            title: Text(
                              'App Info',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppInfoScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ))
              ])
            ]);
          },
        ),
      ),
    );
  }
}
