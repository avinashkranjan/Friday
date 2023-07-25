import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../services/user_info_services.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  String question = 'How can we help?';

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
            Users _user;
            if (userInfo.hasData) _user = userInfo.user!;
            return Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                      children: [
                        SizedBox(height: 30,),
                        Text(
                          "Contact Us",
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                              Text(
                              'Ask a Question',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                              SizedBox(height: 16.0),
                              Text(question, style: TextStyle(color: Colors.white),),
                              SizedBox(height: 8.0),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    question = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Your Question',
                                  border: OutlineInputBorder(),
                                  labelStyle: TextStyle(color: Theme.of(context).primaryColorDark)

                                ),
                                maxLines: 3,
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                child: Text('Send'),
                                onPressed: () {
                                  DateTime now = DateTime.now();
                                  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
                                  // Send the question to your support team
                                  // Implement your logic here
                                },
                              ),])))])]);
          },
        ),
      ),
    );
  }
}
