import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/extra.dart';
import '../models/favorite.dart';
import '../models/food.dart';
import '../repository/cart_repository.dart';
import '../repository/food_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class FoodController extends ControllerMVC {
  Food? food;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite? favorite;
  bool loadCart = false;
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

  // FoodController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  // }

  void listenForFood({String? foodId, String? message}) async {
    final Stream<Food> stream = await getFood(foodId ?? "");
    stream.listen((Food fetchFood) {
      setState(() {
        food = fetchFood;
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).verify_your_internet_connection),
        ));
      }
    }, onDone: () {
      calculateTotal();
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

  void listenForFavorite({String? foodId}) async {
    final Stream<Favorite> stream = await isFavoriteFood(foodId ?? '');
    stream.listen((Favorite fetchFavorite) {
      setState(() {
        favorite = fetchFavorite;
      });
    }, onError: (a) {
      print(a);
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart cart) {
      carts.add(cart);
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
      loadCart = true;
    });
    var newCart = Cart();
    newCart.food = food;
    newCart.extras =
        food.extras?.where((element) => (element.checked ?? false)).toList();
    newCart.quantity = quantity;
    // if food exist in the cart then increment quantity

    var oldCart = isExistInCart(newCart);
    if (oldCart != null) {
      oldCart.quantity = (oldCart.quantity ?? 0) + quantity;
      updateCart(oldCart).then((value) {
        setState(() {
          loadCart = false;
        });
      }).whenComplete(() {
        if (scaffoldKey.currentContext != null && safeContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(S.of(safeContext!).this_food_was_added_to_cart),
          ));
        }
      });
    } else {
      addCart(newCart, reset).then((value) {
        setState(() {
          loadCart = false;
        });
      }).whenComplete(() {
        if (scaffoldKey.currentContext != null && safeContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(S.of(safeContext!).this_food_was_added_to_cart),
          ));
        }
      });
    }
  }

  Cart? isExistInCart(Cart cart) {
    try {
      return carts.firstWhere((Cart oldCart) => cart.isSame(oldCart));
    } catch (e) {
      return null; // Return null if no match is found
    }
    // return carts.firstWhere((Cart oldCart) => cart.isSame(oldCart),
    //     orElse: () => Cart());
  }

  void addToFavorite(Food food) async {
    var favorite = Favorite();
    favorite.food = food;
    favorite.extras = food.extras?.where((Extra extra) {
      return extra.checked ?? false;
    }).toList();
    addFavorite(favorite).then((value) {
      setState(() {
        favorite = value;
      });
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).thisFoodWasAddedToFavorite),
        ));
      }
    });
  }

  void removeFromFavorite(Favorite favorite) async {
    removeFavorite(favorite).then((value) {
      setState(() {
        favorite = Favorite();
      });
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).thisFoodWasRemovedFromFavorites),
        ));
      }
    });
  }

  Future<void> refreshFood() async {
    var id = food?.id;
    food = Food();
    listenForFavorite(foodId: id);
    if (safeContext != null) {
      listenForFood(
          foodId: id, message: S.of(safeContext!).foodRefreshedSuccessfuly);
    }
  }

  void calculateTotal() {
    total = food?.price ?? 0;
    food?.extras?.forEach((extra) {
      total = total + ((extra.checked ?? false) ? (extra.price ?? 0) : 0);
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (quantity <= 99) {
      ++quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (quantity > 1) {
      --quantity;
      calculateTotal();
    }
  }
}
