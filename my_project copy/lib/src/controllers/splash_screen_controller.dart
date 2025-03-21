import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../helpers/custom_trace.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class SplashScreenController extends ControllerMVC {
  ValueNotifier<Map<String, double>> progress = ValueNotifier({});
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// ✅ Updated `safeContext` to prevent `null` errors
  BuildContext? get safeContext {
    return state?.context ??
        scaffoldKey.currentContext ??
        settingRepo.navigatorKey.currentContext;
  }

  SplashScreenController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    progress.value = {"Setting": 0, "User": 0};
  }

  @override
  void initState() {
    super.initState();

    firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    settingRepo.setting.addListener(() {
      if (settingRepo.setting.value.appName != '') {
        progress.value["Setting"] = 41;
        progress.notifyListeners();
      }
    });

    userRepo.currentUser.addListener(() {
      progress.value["User"] = 59;
      progress.notifyListeners();
    });

    try {
      fcmOnLaunchListeners();
      fcmOnResumeListeners();
      fcmOnMessageListeners();
    } catch (e) {
      print("Error initializing FCM listeners: ${e.toString()}");
    }

    /// ✅ Ensure `safeContext` is available before accessing it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (safeContext != null) {
        ScaffoldMessenger.of(safeContext!).showSnackBar(
          SnackBar(
            content: Text(S.of(safeContext!).verify_your_internet_connection),
          ),
        );
      } else {
        print("safeContext is null, skipping SnackBar");
      }
    });

    /// ✅ Use a Timer safely
    Timer(Duration(seconds: 20), () {
      if (safeContext != null) {
        ScaffoldMessenger.of(safeContext!).showSnackBar(
          SnackBar(
            content: Text(S.of(safeContext!).verify_your_internet_connection),
          ),
        );
      } else {
        print("safeContext is null, skipping SnackBar");
      }
    });
  }

  /// Handles incoming FCM messages when the app is in the foreground
  Future fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Fluttertoast.showToast(
        msg: message.notification?.title ?? '',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 6,
      );
    });
  }

  /// Handles FCM messages received when the app is launched from a terminated state
  Future fcmOnLaunchListeners() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      String messageId = await settingRepo.getMessageId();
      try {
        if (messageId != message.messageId) {
          await settingRepo.saveMessageId(message.messageId ?? "");
          if (message.data['id'] == "orders") {
            settingRepo.navigatorKey.currentState
                ?.pushReplacementNamed('/Pages', arguments: 3);
          } else if (message.data['id'] == "messages") {
            settingRepo.navigatorKey.currentState
                ?.pushReplacementNamed('/Pages', arguments: 4);
          }
        }
      } catch (e) {
        print(CustomTrace(StackTrace.current, message: e.toString()));
      }
    }
  }

  /// Handles FCM messages received when the app is resumed from the background
  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(CustomTrace(StackTrace.current, message: message.data['id']));
      try {
        if (message.data['id'] == "orders") {
          settingRepo.navigatorKey.currentState
              ?.pushReplacementNamed('/Pages', arguments: 3);
        } else if (message.data['id'] == "messages") {
          settingRepo.navigatorKey.currentState
              ?.pushReplacementNamed('/Pages', arguments: 4);
        }
      } catch (e) {
        print(CustomTrace(StackTrace.current, message: e.toString()));
      }
    });
  }
}














// import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import '../../generated/l10n.dart';
// import '../helpers/custom_trace.dart';
// import '../repository/settings_repository.dart' as settingRepo;
// import '../repository/user_repository.dart' as userRepo;

// class SplashScreenController extends ControllerMVC {
//   ValueNotifier<Map<String, double>> progress = ValueNotifier({});
//   // GlobalKey<ScaffoldState> scaffoldKey;
//   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   BuildContext? get safeContext {
//     return state?.context ?? scaffoldKey.currentContext;
//   }

//   SplashScreenController() {
//     scaffoldKey = GlobalKey<ScaffoldState>();
//     // Should define these variables before the app loaded
//     progress.value = {"Setting": 0, "User": 0};
//   }

//   @override
//   void initState() async {
//     super.initState();
//     firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     settingRepo.setting.addListener(() {
//       if (settingRepo.setting.value.appName != '') {
//         progress.value["Setting"] = 41;
//         // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//         progress.notifyListeners();
//       }
//     });
//     userRepo.currentUser.addListener(() {
//       progress.value["User"] = 59;
//       progress.notifyListeners();
//     });
//     try {
//       await fcmOnLaunchListeners();
//       await fcmOnResumeListeners();
//       await fcmOnMessageListeners();
//     } catch (e) {
//       print(e.toString());
//     }

//     Timer(Duration(seconds: 20), () {
//       ScaffoldMessenger.of(safeContext!).showSnackBar(SnackBar(
//         content: Text(S.of(safeContext!).verify_your_internet_connection),
//       ));
//     });
//   }

//   Future fcmOnMessageListeners() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       Fluttertoast.showToast(
//         msg: message.notification?.title ?? '',
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.TOP,
//         timeInSecForIosWeb: 6,
//       );
//     });
//   }

//   Future fcmOnLaunchListeners() async {
//     RemoteMessage? message =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (message != null) {
//       String messageId = await settingRepo.getMessageId();
//       try {
//         if (messageId != message.messageId) {
//           await settingRepo.saveMessageId(message.messageId ?? "");
//           if (message.data['id'] == "orders") {
//             settingRepo.navigatorKey.currentState
//                 ?.pushReplacementNamed('/Pages', arguments: 3);
//           } else if (message.data['id'] == "messages") {
//             settingRepo.navigatorKey.currentState
//                 ?.pushReplacementNamed('/Pages', arguments: 4);
//           }
//         }
//       } catch (e) {
//         print(CustomTrace(StackTrace.current, message: e.toString()));
//       }
//     }
//   }

//   Future fcmOnResumeListeners() async {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print(CustomTrace(StackTrace.current, message: message.data['id']));
//       try {
//         if (message.data['id'] == "orders") {
//           settingRepo.navigatorKey.currentState
//               ?.pushReplacementNamed('/Pages', arguments: 3);
//         } else if (message.data['id'] == "messages") {
//           settingRepo.navigatorKey.currentState
//               ?.pushReplacementNamed('/Pages', arguments: 4);
//         }
//       } catch (e) {
//         print(CustomTrace(StackTrace.current, message: e.toString()));
//       }
//     });
//   }
// }
