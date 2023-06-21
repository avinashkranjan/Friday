import 'package:firebase_core/firebase_core.dart';
import 'package:friday/screens/splash.dart';

import 'package:friday/utils/bottom_navbar_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

///Project Local Imports
import 'package:friday/services/authentication.dart';
import 'package:friday/services/user_info_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MultiProvider(
      ///Adding providers for App
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserInfoServices(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavigationBarProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Friday',
        theme: ThemeData(
          primaryColor: Color(0xFF202328),
          backgroundColor: Color(0xFF12171D),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF651FFF)),
        ),
        home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen(key: UniqueKey());
            } else {
              return AuthenticationService.handleEntryPoint(context);
            }
          },
        ),
      ),
    );
  }
}
