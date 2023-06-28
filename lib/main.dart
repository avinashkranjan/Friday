import 'package:firebase_core/firebase_core.dart';
import 'package:friday/screens/onboarding_page.dart';
import 'package:friday/screens/splash.dart';

import 'package:friday/utils/bottom_navbar_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';

///Project Local Imports
import 'package:friday/services/authentication.dart';
import 'package:friday/services/user_info_services.dart';

import 'onboarding/introslider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool k = true;
  Future<bool> isfirstrun() async{
    k = await IsFirstRun.isFirstRun();
    print('yewalachalgaya bsdk');
    print(k.toString());
    return !k;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isfirstrun();
  }



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
          visualDensity: VisualDensity.adaptivePlatformDensity, 
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Color(0xFF651FFF)).copyWith(
              background: Color(0xFF12171D)),
        ),
        home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen(key: UniqueKey());
            } else {
              return k?OnBoardingPage():AuthenticationService.handleEntryPoint(context);
            }
          },
        ),
      ),
    );
  }
}
