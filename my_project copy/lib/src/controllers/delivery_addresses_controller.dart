import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends ControllerMVC with ChangeNotifier {
  List<model.Address> addresses = <model.Address>[];
  // GlobalKey<ScaffoldState> scaffoldKey;
  Cart? cart;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // BuildContext get safeContext {
  //   return state?.context ?? scaffoldKey.currentContext!;
  // }
  BuildContext? get safeContext {
    return state?.context ??
        scaffoldKey.currentContext ??
        settingRepo.navigatorKey.currentContext;
  }

  // DeliveryAddressesController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  //   listenForAddresses();
  //   listenForCart();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForAddresses();
    listenForCart();
  }

  void listenForAddresses({String? message}) async {
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses.add(_address);
      });
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

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    if(safeContext!=null){
    listenForAddresses(
        message: S.of(safeContext!).addresses_refreshed_successfuly);}
  }

  Future<void> changeDeliveryAddress(model.Address address) async {
    await settingRepo.changeCurrentLocation(address);
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  Future<void> changeDeliveryAddressToCurrentLocation() async {
    model.Address _address = await settingRepo.setCurrentLocation();
    setState(() {
      settingRepo.deliveryAddress.value = _address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        this.addresses.insert(0, value);
      });
      if (scaffoldKey.currentContext != null && safeContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext!).new_address_added_successfully),
        ));
      }
    });
  }

  void chooseDeliveryAddress(model.Address address) {
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {});
      addresses.clear();
      if(safeContext!=null){
      listenForAddresses(
          message: S.of(safeContext!).the_address_updated_successfully);}
    });
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      if (scaffoldKey.currentContext != null && safeContext!=null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content:
              Text(S.of(safeContext!).delivery_address_removed_successfully),
        ));
      }
    });
  }
}
