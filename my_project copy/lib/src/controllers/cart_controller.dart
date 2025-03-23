import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/restaurant.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext? get safeContext {
    return state?.context ??
        scaffoldKey.currentContext ??
        settingRepo.navigatorKey.currentContext;
  }

  String typePaymenyt = "";
  String selectedOption = ""; // Default to 'Delivery'
  String? paymentForDelivery;

  void updateDeliveryOption(String option) {
    selectedOption = option;
    notifyListeners(); // Ensure UI rebuild if using a state management solution like Provider
  }

  void listenForCarts({String? message}) async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart cart) {
      if (!carts.contains(cart)) {
        setState(() {
          if (cart.food != null) {
            coupon = cart.food!.applyCoupon(coupon);
            carts.add(cart);
          }
        });
      }
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).verify_your_internet_connection),
        ));
      }
    }, onDone: () async {
      if (carts.isNotEmpty) {
        calculateSubtotal("Free");
      }
      if (message != null) {
        if (scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      }
      onLoadingCartDone();
    });
  }

  Future<void> saveDefaultToSharedPreferences() async {
    // Get the instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the string value with the given key
    await prefs.setString('payment_type', "NO_DELIVERY_FEE");
  }

  void onLoadingCartDone() {}

  void listenForCartsCount({String? message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int count) {
      setState(() {
        cartCount = count;
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null && safeContext != null) {
        BuildContext? context = state?.context ?? scaffoldKey.currentContext;
        if (context != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(S.of(safeContext!).verify_your_internet_connection),
          ));
        }
      }
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    if (safeContext != null) {
      listenForCarts(message: S.of(safeContext!).carts_refreshed_successfuly);
    }
  }

  void removeFromCart(Cart cart) async {
    setState(() {
      carts.remove(cart);
    });
    removeCart(cart).then((value) {
      calculateSubtotal("Free");
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S
              .of(safeContext!)
              .the_food_was_removed_from_your_cart(cart.food?.name ?? '')),
        ));
      }
    });
  }

  void calculateSubtotal(String free) async {
    //debugPrint("llll -- $free");
    double cartPrice = 0;
    subTotal = 0;
    for (var cart in carts) {
      cartPrice = cart.food?.price ?? 0;
      cart.extras?.forEach((element) {
        cartPrice += (element.price ?? 0);
      });
      cartPrice *= cart.quantity ?? 0;
      subTotal += cartPrice;
    }
    if (Helper.canDelivery((carts[0].food?.restaurant ?? Restaurant()),
        carts: carts)) {
      //debugPrint("del click $deliveryFee");
      deliveryFee = 0.0;
      if (free == "Free") {
        //deliveryFee =0.0;
        //debugPrint("if click $deliveryFee");
        taxAmount = (subTotal + deliveryFee) *
            (carts[0].food?.restaurant?.defaultTax ?? 0) /
            100;
        deliveryFee = (carts[0].food?.restaurant?.deliveryFee ?? 0);
//force delivery fee added above
        total = subTotal + taxAmount + deliveryFee;
      } else {
        taxAmount = (subTotal + deliveryFee) *
            (carts[0].food?.restaurant?.defaultTax ?? 0) /
            100;
        deliveryFee = (carts[0].food?.restaurant?.deliveryFee ?? 0);
        total = subTotal + taxAmount + deliveryFee;
        //debugPrint("else click $deliveryFee");
      }
      //deliveryFee =/* carts[0].food.restaurant.deliveryFee*/10.00;
    }
    // debugPrint("carts $carts ");
    //debugPrint("carts $carts .subTotal $subTotal.deliveryFee $deliveryFee . Totalis $total  ");
    setState(() {});
  }

  void doApplyCoupon(String code, {String? message}) async {
    coupon = Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon coupon) async {
      coupon = coupon;
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).verify_your_internet_connection),
        ));
      }
    }, onDone: () {
      listenForCarts();
//      saveCoupon(currentCoupon).then((value) => {
//          });
    });
  }

  incrementQuantity(Cart cart) {
    if ((cart.quantity ?? 0) <= 99) {
      cart.quantity = (cart.quantity ?? 0) + 1;
      updateCart(cart);
      calculateSubtotal("Free");
    }
  }

  decrementQuantity(Cart cart) {
    if ((cart.quantity ?? 0) > 1) {
      cart.quantity = (cart.quantity ?? 0) - 1;
      updateCart(cart);
      calculateSubtotal("Free");
    } else {
      removeFromCart(cart);
    }
  }

  void goCheckout(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(context).completeYourProfileDetailsToContinue),
          action: SnackBarAction(
            label: S.of(context).settings,
            textColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              Navigator.of(context).pushNamed('/Settings');
            },
          ),
        ));
      }
    } else {
      if (carts[0].food?.restaurant?.closed ?? false) {
        if (scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(S.of(context).verify_your_internet_connection),
          ));
        }
      } else {
        //commented bu abhinav
        Navigator.of(context).pushNamed('/DeliveryPickup');
        //Navigator.of(context).pushNamed('/PaymentMethod');
      }
    }
  }

  Color getCouponIconColor() {
    print(coupon.toMap());
    if (coupon.valid == true) {
      return Colors.green;
    } else if (coupon.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(safeContext!).focusColor.withOpacity(0.7);
  }
}
