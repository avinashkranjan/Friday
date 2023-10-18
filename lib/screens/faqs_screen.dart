import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../services/user_info_services.dart';

class FAQScreen extends StatelessWidget {
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
            Users _user;
            if (userInfo.hasData) _user = userInfo.user!;
            return Stack(alignment: Alignment.center, children: [
              Column(children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "FAQs Section",
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
                          FAQItem(
                            question: 'How to edit profile?',
                            answer:
                                'To edit your profile, go to the "Profile" screen and tap on the edit button. Make the necessary changes and save them.',
                          ),
                          FAQItem(
                            question: 'How to add an assignment?',
                            answer:
                                'You can directly add an assignment from the home screen. Tap on the "+" button, enter the assignment details, and save it.',
                          ),
                          FAQItem(
                            question: 'Can I edit or delete a reminder?',
                            answer:
                                'Yes, you can edit or delete a reminder. Tap on the reminder item to edit its details or swipe left and tap on the "Delete" button.',
                          ),
                          FAQItem(
                            question: 'How do I change the app settings?',
                            answer:
                                'To change the app settings, go to the "Settings" screen accessible from the app drawer menu. Here, you can customize various preferences.',
                          ),
                          FAQItem(
                            question: 'How to contact us?',
                            answer:
                                'If you need to contact us, go to the "Help" screen and tap on the "Contact" option. Fill in the required details and send us a message.',
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

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Theme.of(context).highlightColor,
      collapsedIconColor: Theme.of(context).highlightColor,
      title: Text(
        question,
        style: TextStyle(color: Theme.of(context).highlightColor),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            answer,
            style: TextStyle(color: Theme.of(context).canvasColor),
          ),
        ),
      ],
    );
  }
}
