import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../models/gallery.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';
import '../repository/gallery_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class RestaurantController extends ControllerMVC {
  Restaurant? restaurant;
  List<Gallery> galleries = <Gallery>[];
  List<Food> foods = <Food>[];
  List<Category> categories = <Category>[];
  List<Food> trendingFoods = <Food>[];
  List<Food> featuredFoods = <Food>[];
  List<Review> reviews = <Review>[];
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

  // RestaurantController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  // }

  Future<dynamic> listenForRestaurant({String? id, String? message}) async {
    final whenDone = Completer();
    final Stream<Restaurant> stream =
        await getRestaurant(id ?? '', deliveryAddress.value);
    stream.listen((Restaurant restaurant) {
      setState(() => restaurant = restaurant);
      return whenDone.complete(restaurant);
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).verify_your_internet_connection),
        ));
      }
      return whenDone.complete(Restaurant.fromJSON({}));
    }, onDone: () {
      if (message != null) {
        if (scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
        return whenDone.complete(restaurant);
      }
    });
    return whenDone.future;
  }

  void listenForGalleries(String idRestaurant) async {
    final Stream<Gallery> stream = await getGalleries(idRestaurant);
    stream.listen((Gallery gallery) {
      setState(() => galleries.add(gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForRestaurantReviews({String? id, String? message}) async {
    final Stream<Review> stream = await getRestaurantReviews(id ?? '');
    stream.listen((Review review) {
      setState(() => reviews.add(review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForFoods(String idRestaurant, {List<String>? categoriesId}) async {
    final Stream<Food> stream = await getFoodsOfRestaurant(idRestaurant,
        categories: categoriesId ?? []);
    stream.listen((Food food) {
      setState(() => foods.add(food));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      restaurant?.name =
          foods.isEmpty ? "" : foods.elementAt(0).restaurant?.name ?? '';
    });
  }

  void listenForTrendingFoods(String idRestaurant) async {
    final Stream<Food> stream =
        await getTrendingFoodsOfRestaurant(idRestaurant);
    stream.listen((Food food) {
      setState(() => trendingFoods.add(food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedFoods(String idRestaurant) async {
    final Stream<Food> stream =
        await getFeaturedFoodsOfRestaurant(idRestaurant);
    stream.listen((Food food) {
      setState(() => featuredFoods.add(food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories(String restaurantId) async {
    final Stream<Category> stream =
        await getCategoriesOfRestaurant(restaurantId);
    stream.listen((Category category) {
      setState(() => categories.add(category));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      if (safeContext != null) {
        categories.insert(
            0, Category.fromJSON({'id': '0', 'name': S.of(safeContext!).all}));
      }
    });
  }

  Future<void> selectCategory(List<String> categoriesId) async {
    foods.clear();
    listenForFoods(restaurant?.id ?? '', categoriesId: categoriesId);
  }

  Future<void> refreshRestaurant() async {
    var id = restaurant?.id;
    restaurant = Restaurant();
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    if (safeContext != null) {
      listenForRestaurant(
          id: id, message: S.of(safeContext!).restaurant_refreshed_successfuly);
    }
    listenForRestaurantReviews(id: id);
    listenForGalleries(id ?? '');
    listenForFeaturedFoods(id ?? '');
  }
}
