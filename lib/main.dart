import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:friday/models/alert.dart';
import 'package:friday/screens/faqs_screen.dart';
import 'package:friday/screens/onboarding_page.dart';
import 'package:friday/screens/splash.dart';
import 'package:friday/screens/faqs_screen.dart';

import 'package:flutter/material.dart';
import 'package:friday/feedback.dart';
import 'package:friday/screens/theme_screen.dart';
import 'package:friday/services/phone_number_verification_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:friday/screens/phone_verification_screen.dart';
import 'package:friday/screens/verify_code_screen.dart';

import 'package:friday/utils/bottom_navbar_tabs.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';

///Project Local Imports
import 'package:friday/services/authentication.dart';
import 'package:friday/services/user_info_services.dart';
import 'screens/settings_screen.dart';
import 'screens/help_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/app_info_screen.dart';
import 'onboarding/introslider.dart';
import 'utils/notifications.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  NotificationService().showNotification(title: 'olalalaaa', body: 'it works');
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstRun = false;
  int backButtonPressCounter = 0;


  @override
  void initState() {
    super.initState();
    checkFirstRun();


    loadpref();
  }

  Future<void> checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstRun = IsFirstRun.isFirstRun() as bool;
    setState(() {
      isFirstRun = isFirstRun;
    });
    prefs.setBool('already_rated', false);
  }
  Future<void> showRatingDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool alreadyRated = prefs.getBool('already_rated') ?? false;
    if (!alreadyRated) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Rate Our App'),
          content: Text('Please take a moment to provide feedback.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/feedback');
              },
              child: Text('Rate Now'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                prefs.setBool('already_rated', true);
              },
              child: Text('Maybe Later'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> onWillPop() async {
    backButtonPressCounter++;
    if (backButtonPressCounter == 2) {
      backButtonPressCounter = 0;
      await showRatingDialog(context);
    }
    return true;
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
      child: WillPopScope(
        onWillPop:onWillPop,
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale('en'),
          supportedLocales: [
            Locale('ru'),
            Locale('en'), // English
            Locale('hi'),
            Locale('mr')// Hindi
          ],
        debugShowCheckedModeBanner: false,
        title: 'Friday',
        theme: ThemeData(
          primaryColor: Color(0xFF202328),
          visualDensity: VisualDensity.adaptivePlatformDensity, 
          colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: Color(0xFF651FFF))
          .copyWith(background: Color(0xFF12171D)),
        ),
        home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen(key: UniqueKey());
            } else {
    if (isFirstRun) {
    return OnBoardingPage();
    } else {
    WidgetsBinding.instance.addPostFrameCallback(
    (_) => showRatingDialog(context),
    );
    return AuthenticationService.handleEntryPoint(context);

    }}}
    ),
          routes: {
            '/feedback': (context) => FeedbackPage(),
            '/settings': (context) => SettingsScreen(),
            '/help': (context) => HelpScreen(),
            '/contact': (context) => ContactUsScreen(),
            '/appInfo': (context) => AppInfoScreen(),
            '/theme':(context) => ThemeScreen(),
            '/faqs':(context) => FAQScreen(),
            '/phoneVerification': (context) => PhoneVerificationScreen(),
            '/verifyCode': (context) => VerifyCodeScreen(phoneNumber: '7267097531', phoneNumberVerificationDb: PhoneNumberVerificationDb(verificationCallback: null),),
          },
        ),
      ),
    );
  }

  void loadpref() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? k = await pref.getStringList('favbool');
    if(k == null) {
      List<String> tmp = [];
      int len = recentAlerts.length;
      for(var i = 0; i < len; i++) {
        tmp.add('false');

      }
      await pref.setStringList('favbool', tmp);
    }
  }
}
