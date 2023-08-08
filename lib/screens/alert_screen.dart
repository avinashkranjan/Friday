import 'package:flutter/material.dart';
import 'package:friday/widgets/recents_alerts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),
              Text(
                AppLocalizations.of(context).recentalerts,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                padding: EdgeInsets.all(35.0),
                height: MediaQuery.of(context).size.height - 123,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: RecentsAlerts(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
