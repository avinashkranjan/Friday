import 'package:friday/screens/loading_screen.dart';
import 'package:friday/screens/signup_additional_details_screen.dart';
import 'package:friday/services/user_info_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:friday/widgets/bottom_navigation.dart';

class AuthHandlingWidget extends StatefulWidget {
  final String name, email;

  const AuthHandlingWidget({required Key key, required this.name, required this.email}) : super(key: key);
  @override
  _AuthHandlingWidgetState createState() => _AuthHandlingWidgetState();
}

class _AuthHandlingWidgetState extends State<AuthHandlingWidget> {
  Future<bool>? checkingUserDetails;
  @override
  void initState() {
    super.initState();
    checkingUserDetails = Provider.of<UserInfoServices>(context, listen: false)
        .fetchUserDetailsFromDatabase(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkingUserDetails,
      builder: (ctx, AsyncSnapshot<bool> isUserExists) {
        if (isUserExists.connectionState == ConnectionState.done) {
           if (isUserExists.data != null && !isUserExists.data!) {
            Provider.of<UserInfoServices>(ctx, listen: false)
                .setEssentialDetailsOfUser(widget.name, widget.email);
            return SignUpAdditionalDetails();
          } else {
            return BottomNavigation();
          }
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
