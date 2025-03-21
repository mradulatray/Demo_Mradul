import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/cuisine.dart';
import '../models/filter.dart';
import '../repository/cuisine_repository.dart';

class FilterController extends ControllerMVC {
  // GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }

  List<Cuisine> cuisines = [];
  late Filter filter;
  late Cart cart;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForFilter().whenComplete(() {
      listenForCuisines();
    });
  }

  // FilterController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  //   listenForFilter().whenComplete(() {
  //     listenForCuisines();
  //   });
  // }

  Future<void> listenForFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    });
  }

  Future<void> saveFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filter.cuisines =
        this.cuisines.where((_f) => (_f.selected ?? false)).toList();
    prefs.setString('filter', json.encode(filter.toMap()));
  }

  void listenForCuisines({String? message}) async {
    cuisines.add(new Cuisine.fromJSON(
        {'id': '0', 'name': S.of(safeContext).all, 'selected': true}));
    final Stream<Cuisine> stream = await getCuisines();
    stream.listen((Cuisine _cuisine) {
      setState(() {
        if (filter.cuisines?.contains(_cuisine) ?? false) {
          _cuisine.selected = true;
          cuisines.elementAt(0).selected = false;
        }
        cuisines.add(_cuisine);
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).verify_your_internet_connection),
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

  Future<void> refreshCuisines() async {
    cuisines.clear();
    listenForCuisines(
        message: S.of(safeContext).addresses_refreshed_successfuly);
  }

  void clearFilter() {
    setState(() {
      filter.open = false;
      filter.delivery = false;
      resetCuisines();
    });
  }

  void resetCuisines() {
    filter.cuisines = [];
    cuisines.forEach((Cuisine _f) {
      _f.selected = false;
    });
    cuisines.elementAt(0).selected = true;
  }

  void onChangeCuisinesFilter(int index) {
    if (index == 0) {
      // all
      setState(() {
        resetCuisines();
      });
    } else {
      setState(() {
        cuisines.elementAt(index).selected =
            !(cuisines.elementAt(index).selected ?? false);
        cuisines.elementAt(0).selected = false;
      });
    }
  }
}
