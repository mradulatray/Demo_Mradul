import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class ProfileController extends ControllerMVC {
  List<Order> recentOrders = [];
  // GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // BuildContext get safeContext {
  //   return state?.context ?? scaffoldKey.currentContext!;
  // }
  BuildContext? get safeContext {
    return state?.context ??
        scaffoldKey.currentContext ??
        settingRepo.navigatorKey.currentContext;
  }

  // ProfileController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  //   listenForRecentOrders();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForRecentOrders();
  }

  void listenForRecentOrders({String? message}) async {
    final Stream<Order> stream = await getRecentOrders();
    stream.listen((Order _order) {
      setState(() {
        recentOrders.add(_order);
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).verify_your_internet_connection),
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

  Future<void> refreshProfile() async {
    recentOrders.clear();
    if (safeContext != null) {
      listenForRecentOrders(
          message: S.of(safeContext!).orders_refreshed_successfuly);
    }
  }
}
