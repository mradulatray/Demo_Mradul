import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/favorite.dart';
import '../repository/food_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class FavoriteController extends ControllerMVC {
  List<Favorite> favorites = <Favorite>[];
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
  // FavoriteController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForFavorites();
  }

  void listenForFavorites({String? message}) async {
    final Stream<Favorite> stream = await getFavorites();
    stream.listen((Favorite _favorite) {
      setState(() {
        favorites.add(_favorite);
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

  Future<void> refreshFavorites() async {
    favorites.clear();
    if(safeContext!=null){
    listenForFavorites(
        message: S.of(safeContext!).favorites_refreshed_successfuly);}
  }
}
