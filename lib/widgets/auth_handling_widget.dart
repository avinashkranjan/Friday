import 'package:class_manager/screens/loading_screen.dart';
import 'package:class_manager/screens/signup_additional_details_screen.dart';
import 'package:class_manager/services/user_info_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation.dart';

class AuthHandlingWidget extends StatefulWidget {
  final String name, email;

  const AuthHandlingWidget({Key key, this.name, this.email}) : super(key: key);
  @override
  _AuthHandlingWidgetState createState() => _AuthHandlingWidgetState();
}

class _AuthHandlingWidgetState extends State<AuthHandlingWidget> {
  Future<bool> checkingUserDetails;
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
          if (!isUserExists.data) {
            Provider.of<UserInfoServices>(ctx, listen: false)
                .setEssentialDetailsOfUser(widget.name, widget.email);
            return SignUpAdditionalDetails();
          } else
            return BottomNavigation();
        } else
          return LoadingScreen();
      },
    );
  }
}
