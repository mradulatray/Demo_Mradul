import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/splash_screen_controller.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import 'menu_list.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController? _con;
  Restaurant? restaurant;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller as SplashScreenController;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    _con?.progress.addListener(() {
      double progress = 0;
      _con?.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress == 100) {
        try {
          // {id: 12, name: GO PRO SUPPLY, latitude: 11, longitude: 12, delivery_fee: 20.0, distance: 0.0}
          // MenuWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: RouteArgument(param: _con.restaurant));

          Navigator.of(context).pushReplacementNamed('/Pages');
          // MenuWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: RouteArgument(param: _con.restaurant));
        } catch (e) {

          
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con?.scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/logo.png',
                width: 250,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 200),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
