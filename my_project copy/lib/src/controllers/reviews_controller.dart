import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/food.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/food_repository.dart' as foodRepo;
import '../repository/order_repository.dart';
import '../repository/restaurant_repository.dart' as restaurantRepo;
import '../repository/settings_repository.dart' as settingRepo;

class ReviewsController extends ControllerMVC {
  Review? restaurantReview;
  List<Review> foodsReviews = [];
  Order? order;
  List<Food> foodsOfOrder = [];
  List<OrderStatus> orderStatus = <OrderStatus>[];
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

  // ReviewsController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();

  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restaurantReview = Review.init("0");
  }

  void listenForOrder({String? orderId, String? message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order order) {
      setState(() {
        order = order;
        foodsReviews = List.generate(
            (order.foodOrders?.length ?? 0), (_) => Review.init("0"));
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).verify_your_internet_connection),
        ));
      }
    }, onDone: () {
      getFoodsOfOrder();
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

  void addFoodReview(Review review, Food food) async {
    foodRepo.addFoodReview(review, food).then((value) {
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content:
              Text(S.of(safeContext!).the_food_has_been_rated_successfully),
        ));
      }
    });
  }

  void addRestaurantReview(Review review) async {
    restaurantRepo
        .addRestaurantReview(
            review, (order?.foodOrders?[0].food?.restaurant ?? Restaurant()))
        .then((value) {
      refreshOrder();
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(
              S.of(safeContext!).the_restaurant_has_been_rated_successfully),
        ));
      }
    });
  }

  Future<void> refreshOrder() async {
    if (safeContext != null) {
      listenForOrder(
          orderId: order?.id,
          message: S.of(safeContext!).reviews_refreshed_successfully);
    }
  }

  void getFoodsOfOrder() {
    order?.foodOrders?.forEach((foodOrder) {
      if (!foodsOfOrder.contains(foodOrder.food)) {
        foodsOfOrder.add(foodOrder.food ?? Food());
      }
    });
  }
}
