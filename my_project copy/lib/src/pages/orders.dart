import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/order.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';
import '../elements/EmptyOrdersWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/user_repository.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersWidget({Key? key, required this.parentScaffoldKey}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController? _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller as OrderController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con?.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).my_orders,
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
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : (_con?.orders.isEmpty ?? false)
              ? EmptyOrdersWidget()
              : RefreshIndicator(
                  onRefresh: _con?.refreshOrders ?? () async {},
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SearchBarWidget(
                            onClickFilter: (value) {},
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: (_con?.orders.length ?? 0),
                          itemBuilder: (context, index) {
                            var _order = _con?.orders.elementAt(index) ?? Order();
                            return OrderItemWidget(
                              expanded: index == 0 ? true : false,
                              order: _order,
                              onCanceled: (e) {
                                _con?.doCancelOrder(_order);
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
