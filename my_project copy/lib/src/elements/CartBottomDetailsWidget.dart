import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';

String deliveryType = "";

class CartBottomDetailsWidget extends StatelessWidget {
  const CartBottomDetailsWidget({
    Key? key,
    required CartController con,
  })  : _con = con,
        super(key: key);

  final CartController _con;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final getPayment = prefs.getString('payment_type') ?? '';
      deliveryType = getPayment;
      //debugPrint("ppttrr " + getPayment);
    });
    _con.refreshCarts;
    return _con.carts.isEmpty
        ? SizedBox(height: 0)
        : Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      offset: Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).subtotal,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Helper.getPrice(_con.subTotal, context,
                          style: Theme.of(context).textTheme.titleMedium ??
                              TextStyle(fontSize: 16),
                          zeroPlaceholder: '0')
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).delivery_fee,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      //amit removed "NO_DELIVERY_FEE"
                      if (/*Helper.canDeliveryNew(_con.carts[0].food.restaurant,deliveryType) &&*/ deliveryType ==
                              "DELIVERY_FEE" ||
                          deliveryType == '')
                        Helper.getPriceNew(0, context,
                            style: Theme.of(context).textTheme.titleMedium ??
                                TextStyle(fontSize: 16),
                            zeroPlaceholder: '0')
                      else
                        Helper.getPriceNew(
                            (_con.carts[0].food?.restaurant?.deliveryFee ?? 0),
                            context,
                            style: Theme.of(context).textTheme.titleMedium ??
                                TextStyle(fontSize: 16),
                            zeroPlaceholder: '0')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${S.of(context).tax} (${_con.carts[0].food?.restaurant?.defaultTax ?? ''}%)',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Helper.getPrice(_con.taxAmount, context,
                          style: Theme.of(context).textTheme.titleMedium ??
                              TextStyle(fontSize: 16))
                    ],
                  ),
                  SizedBox(height: 10),
                  Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: MaterialButton(
                          onPressed: () {
                            _con.goCheckout(context);
                          },
                          disabledColor:
                              Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: !(_con.carts[0].food?.restaurant?.closed ??
                                  true)
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).focusColor.withOpacity(0.5),
                          shape: StadiumBorder(),
                          child: Text(
                            S.of(context).checkout,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyLarge?.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Helper.getPriceNew(_con.total, context,
                            style: (Theme.of(context).textTheme.headlineLarge ??
                                    TextStyle(fontSize: 18))
                                .merge(TextStyle(
                                    color: Theme.of(context).primaryColor)),
                            zeroPlaceholder: 'Free'),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
  }
// Widget build(BuildContext context) {
//   return _con.carts.isEmpty
//       ? SizedBox(height: 0)
//       : Container(
//     height: 200,
//     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//     decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         borderRadius: BorderRadius.only(
//             topRight: Radius.circular(20),
//             topLeft: Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(
//               color: Theme.of(context).focusColor.withOpacity(0.15),
//               offset: Offset(0, -2),
//               blurRadius: 5.0)
//         ]),
//     child: SizedBox(
//       width: MediaQuery.of(context).size.width - 40,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: Text(
//                   S.of(context).subtotal,
//                   style: Theme.of(context).textTheme.bodyText1,
//                 ),
//               ),
//               Helper.getPrice(_con.subTotal, context,
//                   style: Theme.of(context).textTheme.subtitle1,
//                   zeroPlaceholder: '0')
//             ],
//           ),
//           SizedBox(height: 5),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: Text(
//                   S.of(context).delivery_fee,
//                   style: Theme.of(context).textTheme.bodyText1,
//                 ),
//               ),
//               Text(
//                 _con.selectedOption == 'Pay and Pickup'
//                     ? '-' // Show "-" for Pay and Pickup
//                     : Helper.getPrice(
//                   _con.carts[0].food.restaurant.deliveryFee,
//                   context,
//                   style: Theme.of(context).textTheme.subtitle1,
//                   zeroPlaceholder: '0',
//                 ),
//                 style: Theme.of(context).textTheme.subtitle1,
//               ),
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: Text(
//                   '${S.of(context).tax} (${_con.carts[0].food.restaurant.defaultTax}%)',
//                   style: Theme.of(context).textTheme.bodyText1,
//                 ),
//               ),
//               Helper.getPrice(_con.taxAmount, context,
//                   style: Theme.of(context).textTheme.subtitle1)
//             ],
//           ),
//           SizedBox(height: 10),
//           Stack(
//             fit: StackFit.loose,
//             alignment: AlignmentDirectional.centerEnd,
//             children: <Widget>[
//               SizedBox(
//                 width: MediaQuery.of(context).size.width - 40,
//                 child: MaterialButton(
//                   onPressed: () {
//                     _con.goCheckout(context);
//                   },
//                   disabledColor:
//                   Theme.of(context).focusColor.withOpacity(0.5),
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   color: !_con.carts[0].food.restaurant.closed
//                       ? Theme.of(context).accentColor
//                       : Theme.of(context).focusColor.withOpacity(0.5),
//                   shape: StadiumBorder(),
//                   child: Text(
//                     S.of(context).checkout,
//                     textAlign: TextAlign.start,
//                     style: Theme.of(context).textTheme.bodyText1.merge(
//                         TextStyle(
//                             color: Theme.of(context).primaryColor)),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Helper.getPrice(_con.total, context,
//                     style: Theme.of(context).textTheme.headline4.merge(
//                         TextStyle(
//                             color: Theme.of(context).primaryColor)),
//                     zeroPlaceholder: 'Free'),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//         ],
//       ),
//     ),
//   );
// }
}
