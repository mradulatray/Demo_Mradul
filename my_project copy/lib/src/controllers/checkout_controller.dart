import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment? payment;
  CreditCard creditCard = CreditCard();
  bool loading = true;

  // BuildContext get safeContext {
  //   return state?.context ?? scaffoldKey.currentContext!;
  // }
  @override
  BuildContext? get safeContext {
    return state?.context ??
        scaffoldKey.currentContext ??
        settingRepo.navigatorKey.currentContext;
  }

  // CheckoutController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();

  // }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForCreditCard();
  }

  @override
  void onLoadingCartDone() {
    addOrder(carts);
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Provide a default value if the key doesn't exist
    String value = prefs.getString('type') ?? "";
    Order order = Order();
    order.foodOrders = <FoodOrder>[];
    order.tax = carts[0].food?.restaurant?.defaultTax;
    order.order_type = value;

    // debugPrint("Order Type $orderType");
    //debugPrint("mlmAD $value");
    if (value == '/PayOnPickup') {
      order.deliveryFee = 0.0;
    } else {
      order.deliveryFee = carts[0].food?.restaurant?.deliveryFee;
    }
    // _order.deliveryFee = payment.method == 'Pay on Pickup' ?
    // _order.deliveryFee = value == '/PayOnPickup' ?
    // 0.0 :
    // carts[0].food.restaurant.deliveryFee;

    OrderStatus orderStatus = OrderStatus();
    orderStatus.id = '1'; // TODO default order status Id
    order.orderStatus = orderStatus;
    order.deliveryAddress = settingRepo.deliveryAddress.value;
    for (var _cart in carts) {
      FoodOrder foodOrder = FoodOrder();
      foodOrder.quantity = _cart.quantity;
      foodOrder.price = _cart.food?.price;
      foodOrder.food = _cart.food;
      foodOrder.extras = _cart.extras;
      order.foodOrders?.add(foodOrder);
    }
    orderRepo.addOrder(order, payment).then((value) async {
      settingRepo.coupon = Coupon.fromJSON({});
      return value;
    }).then((value) {
      // if (value is Order) {
      setState(() {
        loading = false;
      });
      // }
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).payment_card_updated_successfully),
        ));
      }
    });
  }
}
