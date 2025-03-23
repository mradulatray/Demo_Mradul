import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
// have some changes
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/delivery_addresses_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../models/address.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class PickAddressWidget extends StatefulWidget {
  const PickAddressWidget({Key? key}) : super(key: key);

  @override
  _PickAddressWidgetState createState() => _PickAddressWidgetState();
}

class _PickAddressWidgetState extends StateMVC<PickAddressWidget> {
  DeliveryAddressesController? _con;

  _PickAddressWidgetState() : super(DeliveryAddressesController()) {
    _con = controller as DeliveryAddressesController;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Demo")
      
      //  PlacePicker(
      //   onTapBack: () {
      //     Navigator.pop(context);
      //   },
      //   apiKey: settingsRepo.setting.value.googleMapsKey ?? '',
      //   initialPosition: LatLng(
      //       settingsRepo.deliveryAddress.value.latitude ?? 0,
      //       settingsRepo.deliveryAddress.value.longitude ?? 0),
      //   useCurrentLocation: true,
      //   selectInitialPosition: true,
      //   usePlaceDetailSearch: true,
      //   forceSearchOnZoomChanged: true,
      //   selectedPlaceWidgetBuilder:
      //       (_, selectedPlace, state, isSearchBarFocused) {
      //     if (isSearchBarFocused) {
      //       return Container();
      //     }
      //     Address _address =
      //         Address(address: selectedPlace?.formattedAddress ?? '');
      //     return FloatingCard(
      //       height: 300,
      //       elevation: 0,
      //       bottomPosition: 0.0,
      //       leftPosition: 20,
      //       rightPosition: 20,
      //       color: Colors.transparent,
      //       child: state == SearchingState.Searching
      //           ? Center(child: CircularProgressIndicator())
      //           : Column(
      //               crossAxisAlignment: CrossAxisAlignment.stretch,
      //               children: [
      //                 Container(
      //                   padding: EdgeInsets.only(
      //                       top: 20, bottom: 14, left: 20, right: 20),
      //                   decoration: BoxDecoration(
      //                       color: Theme.of(context).primaryColor,
      //                       borderRadius: BorderRadius.vertical(
      //                           top: Radius.circular(10),
      //                           bottom: Radius.circular(0)),
      //                       boxShadow: [
      //                         BoxShadow(
      //                             color: Theme.of(context)
      //                                 .focusColor
      //                                 .withOpacity(0.1),
      //                             blurRadius: 10,
      //                             offset: Offset(0, 5)),
      //                       ],
      //                       border: Border.all(
      //                           color: Theme.of(context)
      //                               .focusColor
      //                               .withOpacity(0.05))),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.stretch,
      //                     children: [
      //                       Text(
      //                         "Description",
      //                         style: Theme.of(context).textTheme.bodyLarge,
      //                         textAlign: TextAlign.start,
      //                       ),
      //                       TextFormField(
      //                         initialValue: _address.description,
      //                         onChanged: (input) =>
      //                             _address.description = input,
      //                         textAlign: TextAlign.start,
      //                         obscureText: false,
      //                         decoration: InputDecoration(
      //                           hintText: "My Home",
      //                           border: InputBorder.none,
      //                           icon: Icon(Icons.description_outlined),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Container(
      //                   padding: EdgeInsets.only(
      //                       top: 20, bottom: 14, left: 20, right: 20),
      //                   decoration: BoxDecoration(
      //                       color: Theme.of(context).primaryColor,
      //                       borderRadius: BorderRadius.vertical(
      //                           top: Radius.circular(0),
      //                           bottom: Radius.circular(10)),
      //                       boxShadow: [
      //                         BoxShadow(
      //                             color: Theme.of(context)
      //                                 .focusColor
      //                                 .withOpacity(0.1),
      //                             blurRadius: 10,
      //                             offset: Offset(0, 5)),
      //                       ],
      //                       border: Border.all(
      //                           color: Theme.of(context)
      //                               .focusColor
      //                               .withOpacity(0.05))),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.stretch,
      //                     children: [
      //                       Text(
      //                         "Address",
      //                         style: Theme.of(context).textTheme.bodyLarge,
      //                         textAlign: TextAlign.start,
      //                       ),
      //                       TextFormField(
      //                         initialValue: _address.address,
      //                         onChanged: (input) => _address.address = input,
      //                         textAlign: TextAlign.start,
      //                         obscureText: false,
      //                         decoration: InputDecoration(
      //                           hintText:
      //                               "123 Street, City 136, State, Country",
      //                           border: InputBorder.none,
      //                           icon: Icon(Icons.place_outlined),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 SizedBox(height: 10),
      //                 BlockButtonWidget(
      //                   onPressed: () async {
      //                     _con.addAddress(new Address.fromJSON({
      //                       'address': _address.address,
      //                       'latitude': _address.latitude,
      //                       'longitude': _address.longitude,
      //                     }));
      //                     settingsRepo.deliveryAddress.value = _address;
      //                     Navigator.of(context)
      //                         .pushNamed('/Pages', arguments: 2);
      //                   },
      //                   //color: Get.theme.colorScheme.secondary,
      //                   color: Theme.of(context).colorScheme.secondary,

      //                   text: Text(
      //                     "Pick Here",
      //                     style: Theme.of(context)
      //                         .textTheme
      //                         .headlineSmall
      //                         ?.merge(TextStyle(
      //                             color: Theme.of(context).primaryColor)),
      //                   ),
      //                 ),
      //                 SizedBox(height: 10),
      //               ],
      //             ),
      //     );
      //   },
      // ),
    );
  }
}
