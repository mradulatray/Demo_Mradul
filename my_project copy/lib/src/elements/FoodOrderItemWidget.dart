import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/route_argument.dart';

class FoodOrderItemWidget extends StatelessWidget {
  final String heroTag;
  final FoodOrder foodOrder;
  final Order order;

  const FoodOrderItemWidget(
      {Key? key,
      required this.foodOrder,
      required this.order,
      required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      focusColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Food',
            arguments: RouteArgument(id: this.foodOrder.food?.id ?? ''));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: heroTag + (foodOrder.id ?? ''),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  imageUrl: foodOrder.food?.image?.thumb ?? '',
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          foodOrder.food?.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Wrap(
                          children: List.generate(
                              (foodOrder.extras?.length ?? 0), (index) {
                            return Text(
                              (foodOrder.extras?.elementAt(index).name ?? '') +
                                  ', ',
                              style: Theme.of(context).textTheme.bodySmall,
                            );
                          }),
                        ),
                        Text(
                          foodOrder.food?.restaurant?.name ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Helper.getPrice(Helper.getOrderPrice(foodOrder), context,
                          style: Theme.of(context).textTheme.titleMedium ??
                              TextStyle(fontSize: 16)),
                      Text(
                        " x " + foodOrder.quantity.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
