import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/helpers/custom_trace.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  HttpOverrides.global = new MyHttpOverrides();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    settingRepo.initSettings();
    settingRepo.getCurrentLocation();
    userRepo.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          return MaterialApp(
              navigatorKey: settingRepo.navigatorKey,
              title: _setting.appName,
              initialRoute: '/Splash',
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: _setting.mobileLanguage?.value,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: _setting.brightness.value == Brightness.light
                  ? ThemeData(
                      fontFamily: 'Poppins',
                      primaryColor: Colors.white,
                      floatingActionButtonTheme: FloatingActionButtonThemeData(
                          elevation: 0, foregroundColor: Colors.white),
                      brightness: Brightness.light,
                      // accentColor: config.Colors().mainColor(1),
                      dividerColor: config.Colors().accentColor(0.1),
                      focusColor: config.Colors().accentColor(1),
                      hintColor: config.Colors().secondColor(1),
                      textTheme: TextTheme(
                        headlineMedium: TextStyle(
                            fontSize: 20.0,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        headlineLarge: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        displaySmall: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        displayMedium: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                            color: config.Colors().mainColor(1),
                            height: 1.35),
                        displayLarge: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w300,
                            color: config.Colors().secondColor(1),
                            height: 1.5),
                        titleMedium: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        titleLarge: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().mainColor(1),
                            height: 1.35),
                        bodyMedium: TextStyle(
                            fontSize: 12.0,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        bodyLarge: TextStyle(
                            fontSize: 14.0,
                            color: config.Colors().secondColor(1),
                            height: 1.35),
                        labelSmall: TextStyle(
                            fontSize: 12.0,
                            color: config.Colors().accentColor(1),
                            height: 1.35),
                      ),
                    )
                  : ThemeData(
                      fontFamily: 'Poppins',
                      primaryColor: Color(0xFF252525),
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Color(0xFF2C2C2C),
                      // accentColor: config.Colors().mainDarkColor(1),
                      dividerColor: config.Colors().accentColor(0.1),
                      hintColor: config.Colors().secondDarkColor(1),
                      focusColor: config.Colors().accentDarkColor(1),
                      textTheme: TextTheme(
                        headlineMedium: TextStyle(
                            fontSize: 20.0,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        headlineLarge: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        displaySmall: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        displayMedium: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                            color: config.Colors().mainDarkColor(1),
                            height: 1.35),
                        displayLarge: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w300,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.5),
                        titleMedium: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        titleLarge: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: config.Colors().mainDarkColor(1),
                            height: 1.35),
                        bodyMedium: TextStyle(
                            fontSize: 12.0,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        bodyLarge: TextStyle(
                            fontSize: 14.0,
                            color: config.Colors().secondDarkColor(1),
                            height: 1.35),
                        labelSmall: TextStyle(
                            fontSize: 12.0,
                            color: config.Colors().secondDarkColor(0.6),
                            height: 1.35),
                      ),
                    ));
        });
  }
}
