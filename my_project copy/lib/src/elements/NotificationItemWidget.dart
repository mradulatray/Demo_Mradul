import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../helpers/helper.dart';
import '../helpers/swipe_widget.dart';
import '../models/notification.dart' as model;

class NotificationItemWidget extends StatelessWidget {
  final model.Notification notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnRead;
  final VoidCallback onRemoved;

  NotificationItemWidget(
      {Key? key,
      required this.notification,
      required this.onMarkAsRead,
      required this.onMarkAsUnRead,
      required this.onRemoved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnSlide(
      backgroundColor: (notification.read ?? false)
          ? Theme.of(context).scaffoldBackgroundColor
          : Theme.of(context).primaryColor,
      items: <ActionItems>[
        ActionItems(
            icon: (notification.read ?? false)
                ? new Icon(
                    Icons.panorama_fish_eye,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : new Icon(
                    Icons.brightness_1,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            onPress: () {
              if (notification.read ?? false) {
                onMarkAsUnRead();
              } else {
                onMarkAsRead();
              }
            },
            backgroudColor: Theme.of(context).scaffoldBackgroundColor),
        new ActionItems(
            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: new Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            onPress: () {
              onRemoved();
            },
            backgroudColor: Theme.of(context).scaffoldBackgroundColor),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Theme.of(context).focusColor.withOpacity(0.7),
                            Theme.of(context).focusColor.withOpacity(0.05),
                          ])),
                  child: Icon(
                    Icons.notifications,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 40,
                  ),
                ),
                Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  top: -50,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    Helper.of(context).trans(notification.type ?? ''),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyLarge?.merge(
                        TextStyle(
                            fontWeight: (notification.read ?? false)
                                ? FontWeight.w300
                                : FontWeight.w600)),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd | HH:mm')
                        .format(notification.createdAt ?? DateTime.now()),
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
