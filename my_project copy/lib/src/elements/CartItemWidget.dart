import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  Cart cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget(
      {Key? key,
      required this.cart,
      required this.heroTag,
      required this.increment,
      required this.decrement,
      required this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cart.id ?? ''),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.secondary,
        focusColor: Theme.of(context).colorScheme.secondary,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.of(context).pushNamed('/Food',
              arguments: RouteArgument(
                  id: (widget.cart.food?.id ?? ''), heroTag: widget.heroTag));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  imageUrl: (widget.cart.food?.image?.thumb ?? ''),
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.cart.food?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Wrap(
                            children: List.generate(
                                widget.cart.extras?.length ?? 0, (index) {
                              return Text(
                                (widget.cart.extras?.elementAt(index).name ??
                                        '') +
                                    ', ',
                                style: Theme.of(context).textTheme.bodySmall,
                              );
                            }),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: <Widget>[
                              Helper.getPrice(
                                  (widget.cart.food?.price ?? 0), context,
                                  style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge ??
                                      TextStyle(fontSize: 18),
                                  zeroPlaceholder: 'Free'),
                              (widget.cart.food?.discountPrice ?? 0) > 0
                                  ? Helper.getPrice(
                                      (widget.cart.food?.discountPrice ?? 0),
                                      context,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .merge(TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough)))
                                  : SizedBox(height: 0),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.add_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                        Text(widget.cart.quantity.toString(),
                            style: Theme.of(context).textTheme.titleMedium),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.decrement();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.remove_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
