import 'package:class_manager/services/theme.dart';
import 'package:class_manager/services/theme_service.dart';
import 'package:class_manager/utils/bottom_navbar_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

///Project Local Imports
import 'package:class_manager/services/authentication.dart';
import 'package:class_manager/services/user_info_services.dart';

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
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Friday',
        theme: Themes().lightTheme(),
        darkTheme: Themes().darkTheme(),
        themeMode: ThemeService().theme,
        home: AuthenticationService.handleEntryPoint(context),
      ),
    );
  }
}
