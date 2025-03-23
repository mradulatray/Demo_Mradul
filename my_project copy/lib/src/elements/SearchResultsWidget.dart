import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/food.dart';
import 'package:food_delivery_app/src/models/restaurant.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/search_controller.dart' as custom;
import '../elements/CardWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../models/route_argument.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;

  const SearchResultWidget({super.key, required this.heroTag});

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  custom.SearchController? _con;

  _SearchResultWidgetState() : super(custom.SearchController()) {
    _con = controller as custom.SearchController;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                S.of(context).search,
                style: Theme.of(context).textTheme.headlineLarge ??
                    TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                S.of(context).ordered_by_nearby_first,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onSubmitted: (text) async {
                await _con?.refreshSearch(text);
                _con?.saveSearch(text);
              },
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: S.of(context).search_for_restaurants_or_foods,
                hintStyle: (Theme.of(context).textTheme.bodySmall ??
                        TextStyle(fontSize: 16))
                    .merge(TextStyle(fontSize: 14)),
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
              ),
            ),
          ),
          ((_con?.restaurants.isEmpty ?? true) && (_con?.foods.isEmpty ?? true))
              ? CircularLoadingWidget(height: 288)
              : Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            S.of(context).foods_results,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: (_con?.foods.length ?? 0),
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return FoodItemWidget(
                            heroTag: 'search_list',
                            food: (_con?.foods.elementAt(index) ?? Food()),
                          );
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            S.of(context).restaurants_results,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con?.restaurants.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Details',
                                  arguments: RouteArgument(
                                    id: '0',
                                    param: _con?.restaurants.elementAt(index).id,
                                    heroTag: widget.heroTag,
                                  ));
                            },
                            child: CardWidget(
                                restaurant: (_con?.restaurants.elementAt(index) ?? Restaurant()),
                                heroTag: widget.heroTag),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
