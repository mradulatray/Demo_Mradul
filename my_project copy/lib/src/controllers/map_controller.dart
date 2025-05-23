import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import '../helpers/maps_util.dart';
import '../models/address.dart';
import '../models/restaurant.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart' as sett;

class MapController extends ControllerMVC {
  Restaurant? currentRestaurant;
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Marker> allMarkers = <Marker>[];
  Address? currentAddress;
  Set<Polyline> polylines = {};
  CameraPosition? cameraPosition;
  MapsUtil mapsUtil = MapsUtil();
  Completer<GoogleMapController> mapController = Completer();

  void listenForNearRestaurants(
      Address myLocation, Address areaLocation) async {
    final Stream<Restaurant> stream =
        await getNearRestaurants(myLocation, areaLocation);
    stream.listen((Restaurant restaurant) {
      setState(() {
        topRestaurants.add(restaurant);
      });
      // some changes
      // Helper.getMarker(_restaurant.toMap()).then((marker) {
      //   setState(() {
      //     allMarkers.add(marker);
      //   });
      // });
    }, onError: (a) {}, onDone: () {});
  }

  void getCurrentLocation() async {
    try {
      currentAddress = sett.deliveryAddress.value;
      setState(() {
        if (currentAddress?.isUnknown() ?? false) {
          cameraPosition = CameraPosition(
            target: LatLng(40, 3),
            zoom: 4,
          );
        } else {
          cameraPosition = CameraPosition(
            target: LatLng(
                currentAddress?.latitude ?? 0, currentAddress?.longitude ?? 0),
            zoom: 14.4746,
          );
        }
      });
      if (!(currentAddress?.isUnknown() ?? false)) {
        // some changes
        // Helper.getMyPositionMarker(
        //         currentAddress.latitude ?? 0, currentAddress.longitude ?? 0)
        //     .then((marker) {
        //   setState(() {
        //     allMarkers.add(marker);
        //   });
        // });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  void getRestaurantLocation() async {
    try {
      currentAddress = await sett.getCurrentLocation();
      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(double.parse(currentRestaurant?.latitude ?? ''),
              double.parse(currentRestaurant?.longitude ?? '')),
          zoom: 14.4746,
        );
      });
      if (!(currentAddress?.isUnknown() ?? false)) {
        // some changes
        // Helper.getMyPositionMarker(
        //         currentAddress.latitude ?? 0, currentAddress.longitude ?? 0)
        //     .then((marker) {
        //   setState(() {
        //     allMarkers.add(marker);
        //   });
        // });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;

    sett.setCurrentLocation().then((currentAddress) {
      setState(() {
        sett.deliveryAddress.value = currentAddress;
        currentAddress = currentAddress;
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentAddress.latitude, currentAddress.longitude),
        zoom: 14.4746,
      )));
    });
  }

  void getRestaurantsOfArea() async {
    setState(() {
      topRestaurants = <Restaurant>[];
      Address areaAddress = Address.fromJSON({
        "latitude": cameraPosition?.target.latitude,
        "longitude": cameraPosition?.target.longitude
      });
      listenForNearRestaurants(currentAddress ?? Address(), areaAddress);
    });
  }

  void getDirectionSteps() async {
    currentAddress = await sett.getCurrentLocation();
    if (!(currentAddress?.isUnknown() ?? true)) {
      mapsUtil
          .get(
              "origin=${currentAddress?.latitude.toString() ?? ''},${currentAddress?.longitude.toString() ?? ''}&destination=${currentRestaurant?.latitude ?? ''},${currentRestaurant?.longitude ?? ''}&key=${sett.setting.value.googleMapsKey}")
          .then((dynamic res) {
        if (res != null) {
          List<LatLng> latLng = res as List<LatLng>;
          latLng.insert(
              0,
              LatLng(currentAddress?.latitude ?? 0,
                  currentAddress?.longitude ?? 0));
          setState(() {
            polylines.add(Polyline(
                visible: true,
                polylineId: PolylineId(currentAddress.hashCode.toString()),
                points: latLng,
                color: config.Colors().mainColor(0.8),
                width: 6));
          });
        }
      });
    }
  }

  Future refreshMap() async {
    setState(() {
      topRestaurants = <Restaurant>[];
    });
    listenForNearRestaurants(
        currentAddress ?? Address(), currentAddress ?? Address());
  }
}
