import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../repository/order_repository.dart';

class TrackingController extends ControllerMVC {
  Order? order;
  List<OrderStatus> orderStatus = <OrderStatus>[];
  // GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }

  TrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder({String? orderId, String? message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).verify_your_internet_connection),
        ));
      }
    }, onDone: () {
      listenForOrderStatus();
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

  void listenForOrderStatus() async {
    final Stream<OrderStatus> stream = await getOrderStatus();
    stream.listen((OrderStatus _orderStatus) {
      setState(() {
        orderStatus.add(_orderStatus);
      });
    }, onError: (a) {}, onDone: () {});
  }

  List<Step> getTrackingSteps(BuildContext context) {
    List<Step> _orderStatusSteps = [];
    this.orderStatus.forEach((OrderStatus _orderStatus) {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          _orderStatus.status ?? '',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: order?.orderStatus?.id == _orderStatus.id
            ? Text(
                '${DateFormat('HH:mm | yyyy-MM-dd').format(order?.dateTime ?? DateTime(2025))}',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              )
            : SizedBox(height: 0),
        content: SizedBox(
            width: double.infinity,
            child: Text(
              '${Helper.skipHtml(order?.hint ?? '')}',
            )),
        isActive: ((int.tryParse(order?.orderStatus?.id ?? '')) ?? 0) >=
            ((int.tryParse(_orderStatus.id ?? '')) ?? 0),
      ));
    });
    return _orderStatusSteps;
  }

  Future<void> refreshOrder() async {
    order = new Order();
    listenForOrder(message: S.of(safeContext).tracking_refreshed_successfuly);
  }

  void doCancelOrder() {
    cancelOrder(this.order ?? Order()).then((value) {
      setState(() {
        this.order?.active = false;
      });
    }).catchError((e) {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(e),
        ));
      }
    }).whenComplete(() {
      orderStatus = [];
      listenForOrderStatus();
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S
              .of(safeContext)
              .orderThisorderidHasBeenCanceled(this.order?.id ?? '')),
        ));
      }
    });
  }

  bool canCancelOrder(Order order) {
    return order.active == true && order.orderStatus?.id == 1;
  }
}
