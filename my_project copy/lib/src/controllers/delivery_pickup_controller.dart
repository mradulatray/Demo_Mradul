import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {
  // GlobalKey<ScaffoldState> scaffoldKey;
  late model.Address deliveryAddress;
  late PaymentMethodList list;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get safeContext {
    return state?.context ?? scaffoldKey.currentContext!;
  }
  // DeliveryPickupController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  //   super.listenForCarts();
  //   listenForDeliveryAddress();
  //   //print(settingRepo.deliveryAddress.value.toMap());
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.listenForCarts();
    listenForDeliveryAddress();
  }

  void listenForDeliveryAddress({String? message}) async {
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        if (_address != null || _address != "") {
          deliveryAddress = _address;
        } else {
          deliveryAddress = settingRepo.deliveryAddress.value;
          //Do nothing
          // this.deliveryAddress = settingRepo.deliveryAddress.value;
        }
      });
    }, onError: (a) {
      print(a);
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).verify_your_internet_connection),
        ));
      }
    }, onDone: () {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(message ?? ""),
        ));
      }
    });
    /*this.deliveryAddress = settingRepo.deliveryAddress.value;*/
    // print(this.deliveryAddress.id);
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).new_address_added_successfully),
        ));
      }
    });
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
          content: Text(S.of(safeContext).the_address_updated_successfully),
        ));
      }
    });
  }

//need to change for payment methods check.
  PaymentMethod? getPickUpMethod() {
    return list.pickupList?.elementAt(0);
  }

  // PaymentMethod

  getDeliveryMethod() {
    return list.pickupList?.elementAt(1);
  }

  void toggleDelivery() {
    calculateSubtotal("");
    deletePref("payment_type");
    saveStringToSharedPreferences("payment_type", "NO_DELIVERY_FEE");
    // Helper.canDeliveryNew();
    list.pickupList?.forEach((element) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getDeliveryMethod().selected = !getDeliveryMethod().selected;
    });
  }

  void togglePickUp() {
    calculateSubtotal("Free");
    deletePref("payment_type");
    saveStringToSharedPreferences("payment_type", "DELIVERY_FEE");
    list.pickupList?.forEach((element) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getPickUpMethod()?.selected = !(getPickUpMethod()?.selected ?? false);
    });
  }

  // PaymentMethod getSelectedMethod() {
  //     return list.pickupList.firstWhere((element) => element.selected);
  // }
  //
  // @override
  // void goCheckout(BuildContext context) {
  //   print("payment_methodis_"+ getSelectedMethod().route);
  //   //todo 2 type of method 1-PaymentMethod,2-PayOnPickup
  //   //todo commented by Abhinav
  //   //Navigator.of(context).pushNamed(getSelectedMethod().route);
  //     Navigator.of(context).pushNamed('/PaymentMethod');
  //
  // }
  PaymentMethod? getSelectedMethod() {
    return list.pickupList?.firstWhere(
      (element) => element.selected,
      orElse: () => PaymentMethod(
          '', '', '', '', ''), // Return null if no element is found
    );
  }

  Future<void> saveStringToSharedPreferences(String key, String value) async {
    // Get the instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the string value with the given key
    await prefs.setString(key, value);
  }

  Future<void> deletePref(String key) async {
    // Get the instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the string value with the given key
    prefs.remove("payment_type");
  }

  @override
  void goCheckout(BuildContext context) {
    final selectedMethod = getSelectedMethod();
    //print("payment_methodis_" + selectedMethod.route);

    print("Else payment" + (selectedMethod?.route ?? ''));

    // Navigate based on the selected payment method
    // Navigator.of(context).pushNamed(selectedMethod.route);
    saveStringToSharedPreferences("type", selectedMethod?.route ?? '');
    Navigator.of(context).pushNamed('/PaymentMethod');
  }
}
