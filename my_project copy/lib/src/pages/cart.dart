import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/cart.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key? key, required this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController? _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller as CartController;
  }

  @override
  void initState() {
    _con?.listenForCarts();
    _con?.saveDefaultToSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con?.scaffoldKey,
        bottomNavigationBar:
            CartBottomDetailsWidget(con: _con ?? CartController()),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                  widget.routeArgument.param,
                  arguments: RouteArgument(id: widget.routeArgument.id));
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).cart,
            style: (Theme.of(context).textTheme.headlineSmall ??
                    TextStyle(fontSize: 16))
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _con?.refreshCarts ?? () async {},
          child: (_con?.carts.isEmpty ?? false)
              ? EmptyCartWidget()
              : Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    ListView(
                      primary: true,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.shopping_cart,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).shopping_cart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.headlineLarge ??
                                      TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .verify_your_quantity_and_click_checkout,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.only(top: 15, bottom: 120),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: (_con?.carts.length ?? 0),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return CartItemWidget(
                              cart: (_con?.carts.elementAt(index) ?? Cart()),
                              heroTag: 'cart',
                              increment: () {
                                _con?.incrementQuantity(
                                    _con?.carts.elementAt(index) ?? Cart());
                              },
                              decrement: () {
                                _con?.decrementQuantity(
                                    _con?.carts.elementAt(index) ?? Cart());
                              },
                              onDismissed: () {
                                _con?.removeFromCart(
                                    _con?.carts.elementAt(index) ?? Cart());
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 2),
                                blurRadius: 5.0)
                          ]),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        onSubmitted: (String value) {
                          _con?.doApplyCoupon(value);
                        },
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        controller: TextEditingController()
                          ..text = coupon.code ?? '',
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: Theme.of(context).textTheme.bodyLarge,
                          suffixText: coupon.valid == null
                              ? ''
                              : ((coupon.valid ?? false)
                                  ? S.of(context).validCouponCode
                                  : S.of(context).invalidCouponCode),
                          suffixStyle: (Theme.of(context).textTheme.bodySmall ??
                                  TextStyle(fontSize: 16))
                              .merge(
                                  TextStyle(color: _con?.getCouponIconColor())),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(
                              Icons.confirmation_number,
                              color: _con?.getCouponIconColor(),
                              size: 28,
                            ),
                          ),
                          hintText: S.of(context).haveCouponCode,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
