import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class ShoppingCartFloatButtonWidget extends StatefulWidget {
  const ShoppingCartFloatButtonWidget({
    required this.iconColor,
    required this.labelColor,
    required this.routeArgument,
    Key? key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;
  final RouteArgument routeArgument;

  @override
  _ShoppingCartFloatButtonWidgetState createState() =>
      _ShoppingCartFloatButtonWidgetState();
}

class _ShoppingCartFloatButtonWidgetState
    extends StateMVC<ShoppingCartFloatButtonWidget> {
   CartController? _con;

  _ShoppingCartFloatButtonWidgetState() : super(CartController()) {
    _con = controller as CartController;
  }

  @override
  void initState() {
    _con?.listenForCartsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        color: Theme.of(context).colorScheme.secondary,
        shape: StadiumBorder(),
        onPressed: () {
          if (currentUser.value.apiToken != null) {
            Navigator.of(context)
                .pushNamed('/Cart', arguments: widget.routeArgument);
          } else {
            Navigator.of(context).pushNamed('/Login');
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              color: this.widget.iconColor,
              size: 28,
            ),
            Container(
              child: Text(
                (_con?.cartCount.toString() ?? ''),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.merge(
                      TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 9),
                    ),
              ),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: this.widget.labelColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              constraints: BoxConstraints(
                  minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
            ),
          ],
        ),
      ),
    );
  }
}
