import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  // GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }

  // OrderController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  //   listenForOrders();
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForOrders();
  }

  void listenForOrders({String? message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (e) {
      print(e);
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

  void doCancelOrder(Order order) {
    cancelOrder(order).then((value) {
      setState(() {
        order.active = false;
      });
    }).catchError((e) {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(e),
        ));
      }
    }).whenComplete(() {
      //refreshOrders();
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S
              .of(safeContext)
              .orderThisorderidHasBeenCanceled(order.id ?? "")),
        ));
      }
    });
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: S.of(safeContext).order_refreshed_successfuly);
  }
}
