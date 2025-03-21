import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/notification.dart' as model;
import '../repository/notification_repository.dart';

class NotificationController extends ControllerMVC {
  List<model.Notification> notifications = <model.Notification>[];
  int unReadNotificationsCount = 0;
  // GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }

  // NotificationController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  //   listenForNotifications();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForNotifications();
  }

  void listenForNotifications({String? message}) async {
    final Stream<model.Notification> stream = await getNotifications();
    stream.listen((model.Notification _notification) {
      setState(() {
        notifications.add(_notification);
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).verify_your_internet_connection),
        ));
      }
    }, onDone: () {
      if (message != null) {
        if (scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      }
    });
  }

  Future<void> refreshNotifications() async {
    notifications.clear();
    listenForNotifications(
        message: S.of(safeContext).notifications_refreshed_successfuly);
  }

  void doMarkAsReadNotifications(model.Notification _notification) async {
    markAsReadNotifications(_notification).then((value) {
      setState(() {
        --unReadNotificationsCount;
        _notification.read = !(_notification.read ?? true);
      });
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).thisNotificationHasMarkedAsRead),
        ));
      }
    });
  }

  void doMarkAsUnReadNotifications(model.Notification _notification) {
    markAsReadNotifications(_notification).then((value) {
      setState(() {
        ++unReadNotificationsCount;
        _notification.read = !(_notification.read ?? true);
      });
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).thisNotificationHasMarkedAsUnread),
        ));
      }
    });
  }

  void doRemoveNotification(model.Notification _notification) async {
    removeNotification(_notification).then((value) {
      setState(() {
        if (!(_notification.read ?? true)) {
          --unReadNotificationsCount;
        }
        this.notifications.remove(_notification);
      });
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).notificationWasRemoved),
        ));
      }
    });
  }
}
