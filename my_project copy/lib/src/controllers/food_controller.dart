import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/extra.dart';
import '../models/favorite.dart';
import '../models/food.dart';
import '../repository/cart_repository.dart';
import '../repository/food_repository.dart';

class FoodController extends ControllerMVC {
  late Food food;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  late Favorite favorite;
  bool loadCart = false;
  // GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }

  // FoodController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  // }

  void listenForFood({String? foodId, String? message}) async {
    final Stream<Food> stream = await getFood(foodId ?? "");
    stream.listen((Food _food) {
      setState(() => food = _food);
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).verify_your_internet_connection),
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
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  void listenForCart() async {
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
    _newCart.extras =
        food.extras?.where((element) => (element.checked ?? false)).toList();
    _newCart.quantity = this.quantity;
    // if food exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    _oldCart.quantity = (_oldCart.quantity ?? 0) + this.quantity;
    updateCart(_oldCart).then((value) {
      setState(() {
        this.loadCart = false;
      });
    }).whenComplete(() {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).this_food_was_added_to_cart),
        ));
      }
    });
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => Cart());
  }

  void addToFavorite(Food food) async {
    var _favorite = new Favorite();
    _favorite.food = food;
    _favorite.extras = food.extras?.where((Extra _extra) {
      return _extra.checked ?? false;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).thisFoodWasAddedToFavorite),
        ));
      }
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).thisFoodWasRemovedFromFavorites),
        ));
      }
    });
  }

  Future<void> refreshFood() async {
    var _id = food.id;
    food = new Food();
    listenForFavorite(foodId: _id);
    listenForFood(
        foodId: _id, message: S.of(safeContext).foodRefreshedSuccessfuly);
  }

  void calculateTotal() {
    total = food.price ?? 0;
    food.extras?.forEach((extra) {
      total = total + ((extra.checked ?? false) ? (extra.price ?? 0) : 0);
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
