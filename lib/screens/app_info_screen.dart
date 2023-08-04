import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user_info_services.dart';

class AppInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor:  Colors.transparent,

        centerTitle: true,),
      backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.8),

      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Consumer<UserInfoServices>(
          builder: (context, userInfo, _) {
            return Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                      children: [
                        SizedBox(height: 30,),
                        Text(
                          "App Info",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),),
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
                            child:

                            SizedBox(height: MediaQuery.of(context).size.height ,width: MediaQuery.of(context).size.width,child:Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Friday',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).secondaryHeaderColor
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Version 1.0.0',
                                    style: TextStyle(fontSize: 18, color: Theme.of(context).secondaryHeaderColor),

                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Developer: Avinash Ranjan',
                                    style: TextStyle(fontSize: 18, color: Theme.of(context).secondaryHeaderColor),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Email: ranjan.avinash@hotmail.com',
                                    style: TextStyle(fontSize: 18, color: Theme.of(context).secondaryHeaderColor),
                                  ),
                                ],
                              ),
                            ),)])]);
          },
        ),
      ),
    );
  }
}