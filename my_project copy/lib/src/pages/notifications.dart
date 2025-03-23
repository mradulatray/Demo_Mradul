import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/notification_controller.dart';
import '../elements/EmptyNotificationsWidget.dart';
import '../elements/NotificationItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/user_repository.dart';
import '../models/notification.dart' as model;

class NotificationsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const NotificationsWidget({super.key, required this.parentScaffoldKey});
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends StateMVC<NotificationsWidget> {
  NotificationController? _con;

  _NotificationsWidgetState() : super(NotificationController()) {
    _con = controller as NotificationController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con?.scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).notifications,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).colorScheme.secondary),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : RefreshIndicator(
              onRefresh: _con?.refreshNotifications ?? () async {},
              child: (_con?.notifications.isEmpty ?? false)
                  ? EmptyNotificationsWidget()
                  : ListView(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.notifications,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).notifications,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.headlineLarge ??
                                      TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .swipeLeftTheNotificationToDeleteOrReadUnreadIt,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: (_con?.notifications.length ?? 0),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return NotificationItemWidget(
                              notification:
                                  (_con?.notifications.elementAt(index) ??
                                      model.Notification()),
                              onMarkAsRead: () {
                                _con?.doMarkAsReadNotifications(
                                    (_con?.notifications.elementAt(index) ??
                                        model.Notification()));
                              },
                              onMarkAsUnRead: () {
                                _con?.doMarkAsUnReadNotifications(
                                    (_con?.notifications.elementAt(index) ??
                                        model.Notification()));
                              },
                              onRemoved: () {
                                _con?.doRemoveNotification(
                                    (_con?.notifications.elementAt(index) ??
                                        model.Notification()));
                              },
                            );
                          },
                        ),
                      ],
                    ),
            ),
    );
  }
}
