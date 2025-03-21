import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
// have some changes
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/maps_util.dart';
import '../models/address.dart';
import '../models/coupon.dart';
import '../models/setting.dart';

ValueNotifier<Setting> setting = ValueNotifier(Setting());
ValueNotifier<Address> deliveryAddress = ValueNotifier(Address());
Coupon coupon = Coupon.fromJSON({});
final navigatorKey = GlobalKey<NavigatorState>();

Future<Setting> initSettings() async {
  Setting setting;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}settings';
  try {
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200 &&
        response.headers.containsValue('application/json')) {
      if (json.decode(response.body)['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'settings', json.encode(json.decode(response.body)['data']));
        setting = Setting.fromJSON(json.decode(response.body)['data']);
        //debugPrint("AllSettingsHere ---- ${Setting.fromJSON(json.decode(response.body)['data'])}");
        if (prefs.containsKey('language')) {
          setting.mobileLanguage?.value =
              Locale(prefs.getString('language') ?? '', '');
        }
        setting.brightness.value = prefs.getBool('isDark') ?? false
            ? Brightness.dark
            : Brightness.light;
        setting.value = setting;
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        setting.notifyListeners();
      }
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Setting.fromJSON({});
  }
  return setting.value;
}

Future<dynamic> setCurrentLocation() async {
  // var location = new Location();
  // MapsUtil mapsUtil = new MapsUtil();
  // final whenDone = new Completer();
  // Address _address = new Address();
  // location.requestService().then((value) async {
  //   location.getLocation().then((_locationData) async {
  //     String _addressName = await mapsUtil.getAddressName(
  //             new LatLng(
  //                 _locationData.latitude ?? 0, _locationData.longitude ?? 0),
  //             (setting.value.googleMapsKey ?? '')) ??
  //         '';
  //     _address = Address.fromJSON({
  //       'address': _addressName,
  //       'latitude': _locationData.latitude,
  //       'longitude': _locationData.longitude
  //     });
  //     await changeCurrentLocation(_address);
  //     whenDone.complete(_address);
  //   }).timeout(Duration(seconds: 10), onTimeout: () async {
  //     await changeCurrentLocation(_address);
  //     whenDone.complete(_address);
  //     return null;
  //   }).catchError((e) {
  //     whenDone.complete(_address);
  //   });
  // });
  // return whenDone.future;
}

Future<Address> changeCurrentLocation(Address address) async {
  if (!address.isUnknown()) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('delivery_address', json.encode(address.toMap()));
  }
  return address;
}

Future<Address> getCurrentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.clear();
  if (prefs.containsKey('delivery_address')) {
    deliveryAddress.value = Address.fromJSON(
        json.decode(prefs.getString('delivery_address') ?? ''));
    return deliveryAddress.value;
  } else {
    deliveryAddress.value = Address.fromJSON({});
    return Address.fromJSON({});
  }
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}

Future<void> setDefaultLanguage(String language) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', language);
}

Future<String> getDefaultLanguage(String defaultLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('language')) {
    defaultLanguage = prefs.getString('language') ?? '';
  }
  return defaultLanguage;
}

Future<void> saveMessageId(String messageId) async {
  if (messageId.isNotEmpty) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('google.message_id', messageId);
  }
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('google.message_id') ?? '';
}
