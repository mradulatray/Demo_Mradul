import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../pages/favorites.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class DrawerWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  _DrawerWidgetState() : super(ProfileController()) {}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.apiToken != null
                  ? Navigator.of(context).pushNamed('/Profile')
                  : Navigator.of(context).pushNamed('/Login');
            },
            child: currentUser.value.apiToken != null
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    accountName: Text(
                      currentUser.value.name ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    accountEmail: Text(
                      currentUser.value.email ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    currentAccountPicture: Stack(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(80)),
                            child: CachedNetworkImage(
                              height: 80,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: currentUser.value.image?.thumb ?? "",
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 80,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: currentUser.value.verifiedPhone ?? false
                              ? Icon(
                                  Icons.check_circle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 24,
                                )
                              : SizedBox(),
                        )
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 32,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(1),
                        ),
                        SizedBox(width: 30),
                        Text(
                          S.of(context).guest,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 1);
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).home,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          // Notification hidden Here

          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 0);
          //   },
          //   leading: Icon(
          //     Icons.notifications,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).notifications,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              Icons.local_mall,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).my_orders,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              //FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
              // Navigator.of(context).pushNamed('/Favorites');
              Navigator.of(context).pushNamed('/Favorites', arguments: 0);
            },
            leading: Icon(
              Icons.favorite,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).favorite_foods,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 2);
          //   },
          //   leading: Icon(
          //     Icons.chat,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).messages,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          ListTile(
            dense: true,
            title: Text(
              S.of(context).application_preferences,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).help__support,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).pushNamed('/Settings');
              } else {
                Navigator.of(context).pushReplacementNamed('/Login');
              }
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).settings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          /*ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).languages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),*/
          /*ListTile(
            onTap: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                setBrightness(Brightness.light);
                setting.value.brightness.value = Brightness.light;
              } else {
                setting.value.brightness.value = Brightness.dark;
                setBrightness(Brightness.dark);
              }
              setting.notifyListeners();
            },
            leading: Icon(
              Icons.brightness_6,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark
                  ? S.of(context).light_mode
                  : S.of(context).dark_mode,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),*/
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                logout().then((value) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Pages', (Route<dynamic> route) => false,
                      arguments: 2);
                });
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              currentUser.value.apiToken != null
                  ? S.of(context).log_out
                  : S.of(context).login,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          currentUser.value.apiToken == null
              ? ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/SignUp');
                  },
                  leading: Icon(
                    Icons.person_add,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).register,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              : SizedBox(height: 0),
          (setting.value.enableVersion ?? false)
              ? ListTile(
                  dense: true,
                  title: Text(
                    S.of(context).version +
                        " " +
                        (setting.value.appVersion ?? ''),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
