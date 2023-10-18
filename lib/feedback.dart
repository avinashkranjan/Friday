import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _commentController = TextEditingController();
  double rating = 0.0;
  bool alreadyRated = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyRated();
  }

  void _checkIfAlreadyRated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool alreadyRated = prefs.getBool('already_rated') ?? false;
    setState(() {
      alreadyRated = alreadyRated;
    });
  }

  void _submitFeedback() {
    // Submit the feedback to your backend service or database
    // String comment = _commentController.text;
    // Store the feedback and rating

    // Update the alreadyRated flag
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('already_rated', true);
    });

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank you for your feedback!'),
        content: const Text('Your feedback has been submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comment',
              ),
            ),
            const SizedBox(height: 16.0),
            RatingBar(
              onRatingChanged: (rating) {
                setState(() {
                  rating = rating;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBar extends StatefulWidget {
  final Function(double) onRatingChanged;

  RatingBar({required this.onRatingChanged});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double _rating = 0.0;

  Widget _buildStar(int index) {
    IconData iconData = index <= _rating ? Icons.star : Icons.star_border;
    return GestureDetector(
      onTap: () {
        setState(() {
          _rating = index.toDouble();
          widget.onRatingChanged(_rating);
        });
      },
      child: Icon(iconData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) => _buildStar(index + 1)),
    );
  }
}
