import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/food_controller.dart';
import '../elements/AddToCartAlertDialog.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ExtraItemWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

// ignore: must_be_immutable
class FoodWidget extends StatefulWidget {
  RouteArgument routeArgument;

  FoodWidget({Key? key, required this.routeArgument}) : super(key: key);

  @override
  _FoodWidgetState createState() {
    return _FoodWidgetState();
  }
}

class _FoodWidgetState extends StateMVC<FoodWidget> {
  late FoodController _con;

  _FoodWidgetState() : super(FoodController()) {
    _con = controller as FoodController;
  }

  @override
  void initState() {
    _con.listenForFood(foodId: widget.routeArgument.id);
    _con.listenForCart();
    _con.listenForFavorite(foodId: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: _con.food.image == null
          ? CircularLoadingWidget(height: 500)
          : RefreshIndicator(
              onRefresh: _con.refreshFood,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 125),
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.9),
                          expandedHeight: 300,
                          elevation: 0,
                          iconTheme: IconThemeData(
                              color: Theme.of(context).primaryColor),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Hero(
                              tag: widget.routeArgument.heroTag ??
                                  '' + (_con.food.id ?? ''),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _con.food.image?.url ?? '',
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Wrap(
                              runSpacing: 8,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _con.food.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                          Text(
                                            _con.food.restaurant?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Helper.getPrice(
                                            _con.food.price ?? 0,
                                            context,
                                            style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium ??
                                                TextStyle(fontSize: 14),
                                          ),
                                          (_con.food.discountPrice ?? 0) > 0
                                              ? Helper.getPrice(
                                                  (_con.food.discountPrice ??
                                                      0),
                                                  context,
                                                  style: (Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium ??
                                                          TextStyle(
                                                              fontSize: 14))
                                                      .merge(TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough)))
                                              : SizedBox(height: 0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: Helper.canDelivery(
                                                      _con.food.restaurant ??
                                                          Restaurant()) &&
                                                  (_con.food.deliverable ??
                                                      false)
                                              ? Colors.green
                                              : Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      child: Helper.canDelivery(
                                                  _con.food.restaurant ??
                                                      Restaurant()) &&
                                              (_con.food.deliverable ?? false)
                                          ? Text(
                                              S.of(context).deliverable,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            )
                                          : Text(
                                              S.of(context).not_deliverable,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                            ),
                                    ),
                                    /*  Expanded(child: SizedBox(height: 0)),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(color: Theme.of(context).focusColor, borderRadius: BorderRadius.circular(24)),
                                        child: Text(
                                          _con.food.weight + " " + _con.food.unit,
                                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                        )),*/
                                    SizedBox(width: 5),
                                    /*  Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(color: Theme.of(context).focusColor, borderRadius: BorderRadius.circular(24)),
                                        child: Text(
                                          _con.food.packageItemsCount + " " + S.of(context).items,
                                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                        )),*/
                                  ],
                                ),
                                Divider(height: 20),
                                // some changes
                                // Helper.applyHtml(
                                //     context, (_con.food.description ?? ''),
                                //     style: TextStyle(fontSize: 12)),
                                // Divider(height: 20),
                                // Helper.applyHtml(
                                //     context, (_con.food.units ?? ''),
                                //     style: TextStyle(fontSize: 12)),
                                /*ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                  leading: Icon(
                                    Icons.add_circle,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).extras,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  subtitle: Text(
                                    S.of(context).select_extras_to_add_them_on_the_food,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),*/
                                _con.food.extraGroups == null
                                    ? CircularLoadingWidget(height: 100)
                                    : ListView.separated(
                                        padding: EdgeInsets.all(0),
                                        itemBuilder:
                                            (context, extraGroupIndex) {
                                          var extraGroup = _con.food.extraGroups
                                              ?.elementAt(extraGroupIndex);
                                          return Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                dense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0),
                                                leading: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                title: Text(
                                                  extraGroup?.name ?? '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ),
                                              // ListView.separated(
                                              //   padding: EdgeInsets.all(0),
                                              //   itemBuilder: (context, extraIndex) {
                                              //     return ExtraItemWidget(
                                              //       extra: _con.food.extras.where((extra) => extra.extraGroupId == extraGroup.id).elementAt(extraIndex),
                                              //       onChanged: _con.calculateTotal,
                                              //     );
                                              //   },
                                              //   separatorBuilder: (context, index) {
                                              //     return SizedBox(height: 20);
                                              //   },
                                              //   itemCount: _con.food.extras.where((extra) => extra.extraGroupId == extraGroup.id).length,
                                              //   primary: false,
                                              //   shrinkWrap: true,
                                              // ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 20);
                                        },
                                        itemCount:
                                            _con.food.extraGroups?.length ?? 0,
                                        primary: false,
                                        shrinkWrap: true,
                                      ),

                                // ListTile(
                                //   dense: true,
                                //   contentPadding: EdgeInsets.symmetric(vertical: 10),
                                //   leading: Icon(
                                //     Icons.donut_small,
                                //     color: Theme.of(context).hintColor,
                                //   ),
                                //   title: Text(
                                //     S.of(context).ingredients,
                                //     style: Theme.of(context).textTheme.subtitle1,
                                //   ),
                                // ),
                                // Helper.applyHtml(context, _con.food.ingredients, style: TextStyle(fontSize: 12)),
                                //
                                //   ListTile(
                                //   dense: true,
                                //   contentPadding: EdgeInsets.symmetric(vertical: 10),
                                //   leading: Icon(
                                //     Icons.local_activity,
                                //     color: Theme.of(context).hintColor,
                                //   ),
                                //   title: Text(
                                //     S.of(context).nutrition,
                                //     style: Theme.of(context).textTheme.subtitle1,
                                //   ),
                                // ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(
                                      (_con.food.nutritions?.length ?? 0),
                                      (index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(0.2),
                                                offset: Offset(0, 2),
                                                blurRadius: 6.0)
                                          ]),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                              (_con.food.nutritions
                                                      ?.elementAt(index)
                                                      .name ??
                                                  ''),
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                          Text(
                                              (_con.food.nutritions
                                                      ?.elementAt(index)
                                                      .quantity)
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                                // ListTile(
                                //   dense: true,
                                //   contentPadding: EdgeInsets.symmetric(vertical: 10),
                                //   leading: Icon(
                                //     Icons.recent_actors,
                                //     color: Theme.of(context).hintColor,
                                //   ),
                                //   title: Text(
                                //     S.of(context).reviews,
                                //     style: Theme.of(context).textTheme.subtitle1,
                                //   ),
                                // ),
                                // ReviewsListWidget(
                                //   reviewsList: _con.food.foodReviews,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 20,
                    child: _con.loadCart
                        ? SizedBox(
                            width: 60,
                            height: 60,
                            child: RefreshProgressIndicator(),
                          )
                        : ShoppingCartFloatButtonWidget(
                            iconColor: Theme.of(context).primaryColor,
                            labelColor: Theme.of(context).hintColor,
                            routeArgument:
                                RouteArgument(param: '/Food', id: _con.food.id),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 150,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                                    S.of(context).quantity,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        _con.decrementQuantity();
                                      },
                                      iconSize: 30,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      icon: Icon(Icons.remove_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    ),
                                    Text(_con.quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    IconButton(
                                      onPressed: () {
                                        _con.incrementQuantity();
                                      },
                                      iconSize: 30,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      icon: Icon(Icons.add_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: _con.favorite.id != null
                                      ? OutlinedButton(
                                          onPressed: () {
                                            _con.removeFromFavorite(
                                                _con.favorite);
                                          },
                                          style: ButtonStyle(
                                              padding: WidgetStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                      vertical: 14)),
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Theme.of(context)
                                                          .primaryColor),
                                              shape: WidgetStateProperty.all(
                                                  StadiumBorder()),
                                              side: WidgetStateProperty.all(
                                                  BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary))),
                                          // padding: EdgeInsets.symmetric(vertical: 14),
                                          // color: Theme.of(context).primaryColor,
                                          // shape: StadiumBorder(),
                                          // borderSide: BorderSide(color: Theme.of(context).accentColor),
                                          child: Icon(
                                            Icons.favorite,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ))
                                      : MaterialButton(
                                          elevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          onPressed: () {
                                            if (currentUser.value.apiToken ==
                                                null) {
                                              Navigator.of(context)
                                                  .pushNamed("/Login");
                                            } else {
                                              _con.addToFavorite(_con.food);
                                            }
                                          },
                                          padding:
                                              EdgeInsets.symmetric(vertical: 14),
                                          color: Theme.of(context).colorScheme.secondary,
                                          shape: StadiumBorder(),
                                          child: Icon(
                                            Icons.favorite,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                ),
                                SizedBox(width: 10),
                                Stack(
                                  fit: StackFit.loose,
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: MaterialButton(
                                        elevation: 0,
                                        focusElevation: 0,
                                        highlightElevation: 0,
                                        onPressed: () {
                                          if (currentUser.value.apiToken ==
                                              null) {
                                            Navigator.of(context)
                                                .pushNamed("/Login");
                                          } else {
                                            if (_con
                                                .isSameRestaurants(_con.food)) {
                                              _con.addToCart(_con.food);
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  // return object of type Dialog
                                                  return AddToCartAlertDialogWidget(
                                                      oldFood: _con.carts
                                                              .elementAt(0)
                                                              .food ??
                                                          Food(),
                                                      newFood: _con.food,
                                                      onPressed: (food,
                                                          {reset = true}) {
                                                        return _con.addToCart(
                                                            _con.food,
                                                            reset: true);
                                                      });
                                                },
                                              );
                                            }
                                          }
                                        },
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        shape: StadiumBorder(),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            S.of(context).add_to_cart,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Helper.getPrice(
                                        _con.total,
                                        context,
                                        style: (Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge ??
                                                TextStyle(fontSize: 18))
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
