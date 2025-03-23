import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/NotDeliverableAddressesItemWidget.dart';
import '../elements/PickUpMethodItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key? key, required this.routeArgument})
      : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController? _con;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller as DeliveryPickupController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con?.scaffoldKey,
      bottomNavigationBar: CartBottomDetailsWidget(con: _con ?? DeliveryPickupController()),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          //S.of(context).delivery_or_pickup,
          S.of(context).delivery,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).colorScheme.secondary),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child:
            //amit pickup starts here
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, right: 10),
            //   child: ListTile(
            //     contentPadding: EdgeInsets.symmetric(vertical: 0),
            //     leading: Icon(
            //       Icons.domain,
            //       color: Theme.of(context).hintColor,
            //     ),
            //     title: Text(
            //       S.of(context).pickup,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //     subtitle: Text(
            //       S.of(context).pickup_your_food_from_the_restaurant,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.caption,
            //     ),
            //   ),
            // ),
            // PickUpMethodItem(
            //     paymentMethod: _con.getPickUpMethod(),
            //     onPressed: (paymentMethod) {
            //       _con.togglePickUp();
            //
            //     }),
            //amit pickup ends here
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.map,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).delivery,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineLarge ??
                          TextStyle(fontSize: 18),
                    ),
                    subtitle: (_con?.carts.isNotEmpty ?? false) &&
                            Helper.canDelivery(
                                (_con?.carts[0].food?.restaurant ??
                                    Restaurant()),
                                carts: _con?.carts)
                        ? Text(
                            S
                                .of(context)
                                .click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : Text(
                            S.of(context).deliveryMethodNotAllowed,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                  ),
                ),
                (_con?.carts
                        .isNotEmpty ?? false)/* && Helper.canDelivery(_con.carts[0].food.restaurant, carts: _con.carts)*/
                    ? DeliveryAddressesItemWidget(
                        paymentMethod: _con?.getDeliveryMethod(),
                        address: _con?.deliveryAddress ?? Address(),
                        onPressed: (Address _address) {
                          //debugPrint("delivery_pickup     ---  ${_con.deliveryAddress}");
                          if (_con?.deliveryAddress == 'null') {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con?.addAddress(_address);
                                _con?.toggleDelivery();
                              },
                            );
                          } else {
                            _con?.toggleDelivery();
                          }
                        },
                        /*onLongPress: (Address _address) {
                          DeliveryAddressDialog(
                            context: context,
                            address: _address,
                            onChanged: (Address _address) {
                              _con.updateAddress(_address);
                            },
                          );
                        },*/
                      )
                    : Text("")
                // :   NotDeliverableAddressesItemWidget() //
              ],
            )
          ],
        ),
      ),
    );
  }
}
