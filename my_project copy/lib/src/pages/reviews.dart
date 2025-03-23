import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_delivery_app/src/models/food.dart';
import 'package:food_delivery_app/src/models/review.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/reviews_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/route_argument.dart';

class ReviewsWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  ReviewsWidget({Key? key, required this.routeArgument}) : super(key: key);

  @override
  _ReviewsWidgetState createState() {
    return _ReviewsWidgetState();
  }
}

class _ReviewsWidgetState extends StateMVC<ReviewsWidget> {
  ReviewsController? _con;

  _ReviewsWidgetState() : super(ReviewsController()) {
    _con = controller as ReviewsController;
  }

  @override
  void initState() {
    _con?.listenForOrder(orderId: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con?.scaffoldKey,
        body: RefreshIndicator(
            onRefresh: _con?.refreshOrder ?? () async {},
            child: _con?.order == null
                ? CircularLoadingWidget(height: 500)
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Hero(
                                      tag:
                                          (widget.routeArgument.heroTag ?? '') +
                                              (_con?.order?.foodOrders?[0].food
                                                      ?.restaurant?.id ??
                                                  ''),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: (_con?.order?.foodOrders?[0]
                                                .food?.restaurant?.image?.url ??
                                            ''),
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/img/loading.gif',
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 110,
                                  child: Chip(
                                    padding: EdgeInsets.all(10),
                                    label: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            (_con?.order?.foodOrders?[0].food
                                                    ?.restaurant?.rate ??
                                                ''),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall
                                                ?.merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor))),
                                        Icon(
                                          Icons.star_border,
                                          color: Theme.of(context).primaryColor,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.9),
                                    shape: StadiumBorder(),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 30,
                              left: 15,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          (_con?.order?.foodOrders?[0].food?.restaurant?.name ??
                              ''),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, -2),
                                    blurRadius: 5.0)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                  S
                                      .of(context)
                                      .how_would_you_rate_this_restaurant_,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _con?.restaurantReview?.rate =
                                            (index + 1).toString();
                                      });
                                    },
                                    child: index <
                                            int.parse(
                                                _con?.restaurantReview?.rate ??
                                                    '')
                                        ? Icon(Icons.star,
                                            size: 40, color: Color(0xFFFFB24D))
                                        : Icon(Icons.star_border,
                                            size: 40, color: Color(0xFFFFB24D)),
                                  );
                                }),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                onChanged: (text) {
                                  _con?.restaurantReview?.review = text;
                                },
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: S
                                      .of(context)
                                      .tell_us_about_this_restaurant,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.merge(TextStyle(fontSize: 14)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.1))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.2))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.1))),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextButton.icon(
                                //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                // textColor: Theme.of(context).primaryColor,
                                // color: Theme.of(context).accentColor,
                                onPressed: () {
                                  _con?.addRestaurantReview(
                                      _con?.restaurantReview ?? Review());
                                  FocusScope.of(context).unfocus();
                                },
                                style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 18)),
                                    backgroundColor: WidgetStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    shape: WidgetStateProperty.all(
                                        StadiumBorder()),
                                    side: WidgetStateProperty.all(BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                    textStyle: WidgetStateProperty.all(TextStyle(
                                        color:
                                            Theme.of(context).primaryColor))),
                                label: Text(
                                  S.of(context).submit,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                icon: Icon(
                                  Icons.check,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children:
                              List.generate(_con?.foodsOfOrder.length ?? 0, (index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.15),
                                        offset: Offset(0, -2),
                                        blurRadius: 5.0)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text((_con?.foodsOfOrder[index].name ?? ''),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (star) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _con?.foodsReviews[index].rate =
                                                (star + 1).toString();
                                          });
                                        },
                                        child: star <
                                                int.parse(_con
                                                        ?.foodsReviews[index]
                                                        .rate ??
                                                    '')
                                            ? Icon(Icons.star,
                                                size: 40,
                                                color: Color(0xFFFFB24D))
                                            : Icon(Icons.star_border,
                                                size: 40,
                                                color: Color(0xFFFFB24D)),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    onChanged: (text) {
                                      _con?.foodsReviews[index].review = text;
                                    },
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(12),
                                      hintText:
                                          S.of(context).tell_us_about_this_food,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.merge(TextStyle(fontSize: 14)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.1))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.2))),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.1))),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextButton.icon(
                                    // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                    // textColor: Theme.of(context).primaryColor,
                                    // color: Theme.of(context).accentColor,
                                    // shape: StadiumBorder(),
                                    style: ButtonStyle(
                                        padding: WidgetStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 18)),
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                        shape: WidgetStateProperty.all(
                                            StadiumBorder()),
                                        //side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).accentColor)),
                                        textStyle: WidgetStateProperty.all(
                                            TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))),
                                    onPressed: () {
                                      _con?.addFoodReview(
                                          _con?.foodsReviews[index] ?? Review(),
                                          _con?.foodsOfOrder[index] ?? Food());
                                      FocusScope.of(context).unfocus();
                                    },
                                    label: Text(
                                      S.of(context).submit,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    icon: Icon(
                                      Icons.check,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )));
  }
}
