import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class CategoryController extends ControllerMVC {
  List<Food> foods = <Food>[];
  // GlobalKey<ScaffoldState> scaffoldKey;
  Category? category;
  bool loadCart = false;
  List<Cart> carts = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  BuildContext? get safeContext {
    return state?.context ??
        scaffoldKey.currentContext ??
        settingRepo.navigatorKey.currentContext;
  }

  // CategoryController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  // }

  void listenForFoodsByCategory({String? id, String? message}) async {
    final Stream<Food> stream = await getFoodsByCategory(id);
    stream.listen((Food _food) {
      setState(() {
        foods.add(_food);
      });
    }, onError: (a) {
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

  void listenForCategory({String? id, String? message}) async {
    final Stream<Category> stream = await getCategory(id ?? "");
    stream.listen((Category _category) {
      setState(() => category = _category);
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

  Future<void> listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  bool isSameRestaurants(Food food) {
    if (carts.isNotEmpty) {
      return carts[0].food?.restaurant?.id == food.restaurant?.id;
    }
    return true;
  }

  void addToCart(Food food, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.food = food;
    _newCart.extras = [];
    _newCart.quantity = 1;
    // if food exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    _oldCart.quantity = (_oldCart.quantity ?? 0) + 1;
    updateCart(_oldCart).then((value) {
      setState(() {
        this.loadCart = false;
      });
    }).whenComplete(() {
      if (scaffoldKey.currentContext != null && safeContext!=null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).this_food_was_added_to_cart),
        ));
      }
    });
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => Cart());
  }

  Future<void> refreshCategory() async {
    foods.clear();
    category = new Category();
    if (safeContext != null) {
    listenForFoodsByCategory(
        message: S.of(safeContext!).category_refreshed_successfuly);
    listenForCategory(
        message: S.of(safeContext!).category_refreshed_successfuly);
    }
  }
}
