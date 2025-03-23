import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/credit_card.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/CreditCardsWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

String deliveryType = "";

class CheckoutWidget extends StatefulWidget {
//  RouteArgument routeArgument;
//  CheckoutWidget({Key key, this.routeArgument}) : super(key: key);
  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends StateMVC<CheckoutWidget> {
   CheckoutController? _con;

  _CheckoutWidgetState() : super(CheckoutController()) {
    _con = controller as CheckoutController;
  }

  @override
  void initState() {
    _con?.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final getPayment = prefs.getString('type') ?? '';
      deliveryType = getPayment;
      //debugPrint("ppttrr " + getPayment);
    });
    return Scaffold(
      key: _con?.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).checkout,
          style: (Theme.of(context).textTheme.headlineSmall ??
                  TextStyle(fontSize: 16))
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: (_con?.carts.isEmpty ?? false)
          ? CircularLoadingWidget(height: 400)
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 255),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.payment,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).card_details,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.headlineLarge ??
                                      TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              S.of(context).card_privacy,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new CreditCardsWidget(
                            creditCard: (_con?.creditCard ?? CreditCard()),
                            onChanged: (creditCard) {
                              _con?.updateCreditCard(creditCard);
                            }),
                        SizedBox(height: 40),
                        (setting.value.payPalEnabled ?? false)
                            ? Text(
                                S.of(context).or_checkout_with,
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        SizedBox(height: 40),
                        (setting.value.payPalEnabled ?? false)
                            ? SizedBox(
                                width: 320,
                                child: MaterialButton(
                                  elevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/PayPal');
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2),
                                  shape: StadiumBorder(),
                                  child: Image.asset(
                                    'assets/img/paypal2.png',
                                    height: 28,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 255,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.15),
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
                              Helper.getPriceNew(_con?.subTotal ?? 0, context,
                                  style:
                                      Theme.of(context).textTheme.titleMedium ??
                                          TextStyle(fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).delivery_fee,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              if (/*Helper.canDeliveryNew(_con.carts[0].food.restaurant,deliveryType) &&*/ deliveryType ==
                                  '/PaymentMethod')
                                Helper.getPriceNew(
                                    (_con?.carts[0].food?.restaurant
                                            ?.deliveryFee ??
                                        0),
                                    context,
                                    style: Theme.of(context)
                                            .textTheme
                                            .titleMedium ??
                                        TextStyle(fontSize: 16),
                                    zeroPlaceholder: '0')
                              else
                                Helper.getPriceNew(0, context,
                                    style: Theme.of(context)
                                            .textTheme
                                            .titleMedium ??
                                        TextStyle(fontSize: 16),
                                    zeroPlaceholder: '0')
                            ],
                          ),
                          //EDITED 4/12/2024

                          /* Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).delivery_fee,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPriceNew(
                                  _con.carts[0].food.restaurant.deliveryFee,
                                  context,
                                  style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),*/
                          SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "${S.of(context).tax} (${_con?.carts[0].food?.restaurant?.defaultTax}%)",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Helper.getPrice(_con?.taxAmount ?? 0, context,
                                  style:
                                      Theme.of(context).textTheme.titleMedium ??
                                          TextStyle(fontSize: 16))
                            ],
                          ),
                          Divider(height: 30),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).total,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              Helper.getPrice(_con?.total ?? 0, context,
                                  style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall ??
                                      TextStyle(fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: MaterialButton(
                              elevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                              onPressed: () {
                                if (_con?.creditCard.validated() ?? false) {
                                  Navigator.of(context).pushNamed(
                                      '/OrderSuccess',
                                      arguments: new RouteArgument(
                                          param:
                                              'Credit Card (Stripe Gateway)'));
                                } else {
                                  if (_con?.scaffoldKey.currentContext != null) {
                                    ScaffoldMessenger.of(
                                            _con!.scaffoldKey.currentContext!)
                                        .showSnackBar(SnackBar(
                                      content: Text(S
                                          .of(context)
                                          .your_credit_card_not_valid),
                                    ));
                                  }
                                }
                              },
                              padding: EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).colorScheme.secondary,
                              shape: StadiumBorder(),
                              child: Text(
                                S.of(context).confirm_payment,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
