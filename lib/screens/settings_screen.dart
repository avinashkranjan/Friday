import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:friday/screens/faqs_screen.dart';
import 'package:friday/screens/help_screen.dart';
import 'package:friday/screens/themes.dart';
import 'package:friday/utils/notifications.dart';
import 'package:open_url/open_url.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/users.dart';
import '../services/theme_provider.dart';
import '../services/user_info_services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  get visibilityName => null;
  bool modeval = false;

  late bool? notification;
  ThemeData? _currentTheme;

  void _setTheme(ThemeData? theme) {
    if (theme != null) {
      setState(() {
        _currentTheme = theme;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checknotify();
    _currentTheme = ThemeMode.system == ThemeMode.light ? lightTheme : darkTheme;
    super.initState();
  }

  void notificationsInitialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: null);
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(
        defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: null);
  }

  Future<void> checknotify() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notification = prefs.getBool('notification');
    if(notification==null){
      notification = true;
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor:  Theme.of(context).colorScheme.background.withOpacity(0.8),

        centerTitle: true,),
      backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.8),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Consumer<UserInfoServices>(
          builder: (context, userInfo, _) {
            Users _user;
            if (userInfo.hasData) _user = userInfo.user!;
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).settings,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),),
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
                        child:

                        SizedBox(height: MediaQuery.of(context).size.height ,width: MediaQuery.of(context).size.width,child:SettingsList(
                          lightTheme: SettingsThemeData(settingsListBackground: Theme.of(context).primaryColor, titleTextColor: Theme.of(context).secondaryHeaderColor,
                              settingsTileTextColor: Colors.white, leadingIconsColor: Colors.white, dividerColor: Colors.white70, tileDescriptionTextColor: Theme.of(context).primaryColorDark)

                          ,sections: [
                          SettingsSection(

                            title: Text(AppLocalizations.of(context).common),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                leading: Icon(Icons.language),
                                onPressed: (c) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Currently support is for Single language only. Stay tuned!"),
                                  ));
                                },
                                title: Text(AppLocalizations.of(context).language),
                                value: Text('English'),
                              ),
                              SettingsTile.switchTile(initialValue: modeval, onToggle: (s) {
                                final themeProvider =
                                Provider.of<ThemeProvider>(context, listen: false);
                                setState(() {
                                  modeval = s;
                                });
                                if(modeval) {
                                  setState(() {
                                    themeProvider.setLightMode();
                                  });
                                }
                                else {
                                  setState(() {
                                    themeProvider.setDarkmode();
                                  });
                                }

                              }, title: Text(AppLocalizations.of(context).lightmode), enabled: true, leading: Icon(Icons.light_mode),),

                              SettingsTile.navigation(
                                leading: Icon(Icons.notifications_active_outlined),
                                title: Text(AppLocalizations.of(context).notifications),
                                onPressed: (s) async {

                                  NotificationService().showNotification(title: 'olalalaaa', body: 'it works');

                                  //if(notification!){
                                  //await FlutterLocalNotificationsPlugin().cancelAll();
                                  //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  // content: Text("Notifications turned off!"),
                                  //));
                                  //}
                                  //else {
                                  //notificationsInitialize();
                                  //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  // content: Text("Notifications turned on!"),
                                  //));
                                  //}



                                  //notificationsInitialize();
                                },
                                value: Text(AppLocalizations.of(context).notificationsdesc),
                              ),

                              SettingsTile.navigation(
                                leading: Icon(Icons.help_outline),
                                title: Text(AppLocalizations.of(context).help),
                                onPressed: (s) {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpScreen()));
                                },
                                value: Text(AppLocalizations.of(context).helpdesc),
                              ),


                              SettingsTile.navigation(
                                leading: Icon(Icons.info_outlined),
                                title: Text(AppLocalizations.of(context).faqs),
                                value: Text(AppLocalizations.of(context).faqsdesc),
                                onPressed: (s) {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FAQScreen()));
                                },
                              ),
                              SettingsTile.navigation(
                                leading: Icon(Icons.support),
                                title: Text(AppLocalizations.of(context).supportdevelopment),
                                onPressed: (s) async {
                                  //js.context.callMethod('open', ['https://github.com/avinashkranjan/Friday']);
                                  final result = await openUrl('https://github.com/avinashkranjan/Friday');
                                  int a = result.exitCode;
                                  if (a == 0) {
                                    print('URL opened in your system!');
                                    print('\n');
                                  } else {
                                    print('Something went wrong with exit code = ${result.exitCode}: '
                                        '${result.stderr}');
                                  }

                                },
                                value: Text(AppLocalizations.of(context).supportdevelopmentdesc),
                              ),

                            ],
                          ),
                        ],
                        ),)



                    ),

                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
