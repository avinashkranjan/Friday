import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: ListView(
        children: <Widget>[
          FAQItem(
            question: 'How to edit profile?',
            answer: 'To edit your profile, go to the "Profile" screen and tap on the edit button. Make the necessary changes and save them.',
          ),
          FAQItem(
            question: 'How to add an assignment?',
            answer: 'You can directly add an assignment from the home screen. Tap on the "+" button, enter the assignment details, and save it.',
          ),
          FAQItem(
            question: 'Can I edit or delete a reminder?',
            answer: 'Yes, you can edit or delete a reminder. Tap on the reminder item to edit its details or swipe left and tap on the "Delete" button.',
          ),
          FAQItem(
            question: 'How do I change the app settings?',
            answer: 'To change the app settings, go to the "Settings" screen accessible from the app drawer menu. Here, you can customize various preferences.',
          ),
          FAQItem(
            question: 'How to contact us?',
            answer: 'If you need to contact us, go to the "Help" screen and tap on the "Contact" option. Fill in the required details and send us a message.',
          ),
        ],
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
      title: Text(question),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
