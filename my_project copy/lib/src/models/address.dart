import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// have some changes

import '../helpers/custom_trace.dart';

class Address {
  String? id;
  String? description;
  String? address;
  double? latitude;
  double? longitude;
  bool? isDefault;
  String? userId;

  Address(
      {this.id,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      this.isDefault,
      this.userId});

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      description = jsonMap['description'] != null
          ? jsonMap['description'].toString()
          : null;
      address = jsonMap['address'] != null ? jsonMap['address'] : null;
      latitude =
          jsonMap['latitude'] != null ? jsonMap['latitude'].toDouble() : null;
      longitude =
          jsonMap['longitude'] != null ? jsonMap['longitude'].toDouble() : null;
      isDefault = jsonMap['is_default'] ?? false;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e as String));
    }
  }

  bool isUnknown() {
    return latitude == null || longitude == null || id == null || id == 'null';
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    return map;
  }

  // LocationData toLocationData() {
  //   return LocationData.fromMap({
  //     "latitude": latitude,
  //     "longitude": longitude,
  //   });
  // }

  LatLng getLatLng() {
    if (this.isUnknown()) {
      return LatLng(38.806103, 52.4964453);
    } else {
      return LatLng(this.latitude ?? 0, this.longitude ?? 0);
    }
  }
}
