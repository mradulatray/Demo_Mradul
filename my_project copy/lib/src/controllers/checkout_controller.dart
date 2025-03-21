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
  late Payment payment;
  CreditCard creditCard = new CreditCard();
  bool loading = true;

  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
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
    ;
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Provide a default value if the key doesn't exist
    String value = prefs.getString('type') ?? "";
    Order _order = new Order();
    _order.foodOrders = <FoodOrder>[];
    _order.tax = carts[0].food?.restaurant?.defaultTax;
    _order.order_type = value;

    // debugPrint("Order Type $orderType");
    //debugPrint("mlmAD $value");
    if (value == '/PayOnPickup') {
      _order.deliveryFee = 0.0;
    } else {
      _order.deliveryFee = carts[0].food?.restaurant?.deliveryFee;
    }
    // _order.deliveryFee = payment.method == 'Pay on Pickup' ?
    // _order.deliveryFee = value == '/PayOnPickup' ?
    // 0.0 :
    // carts[0].food.restaurant.deliveryFee;

    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = settingRepo.deliveryAddress.value;
    carts.forEach((_cart) {
      FoodOrder _foodOrder = new FoodOrder();
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.food?.price;
      _foodOrder.food = _cart.food;
      _foodOrder.extras = _cart.extras;
      _order.foodOrders?.add(_foodOrder);
    });
    orderRepo.addOrder(_order, this.payment).then((value) async {
      settingRepo.coupon = new Coupon.fromJSON({});
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
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).payment_card_updated_successfully),
        ));
      }
    });
  }
}
