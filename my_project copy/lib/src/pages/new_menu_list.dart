import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/src/models/food.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/setting.dart';
import '../repository/settings_repository.dart' as settingsRepo;

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

class MenuNewWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  // final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //
  const MenuNewWidget({super.key, this.parentScaffoldKey});
  @override
  _MenuNewWidgetState createState() => _MenuNewWidgetState();
  // final RouteArgument routeArgument;
  // final GlobalKey<ScaffoldState> parentScaffoldKey;

  // MenuNewWidget(/*{Key key, this.parentScaffoldKey*//*, this.routeArgument*//*}*/) : super(key: key);
}

class _MenuNewWidgetState extends StateMVC<MenuNewWidget> {
  RestaurantController? _con;
  List<String>? selectedCategories;

  _MenuNewWidgetState() : super(RestaurantController()) {
    _con = controller as RestaurantController;
  }

  @override
  void initState() {
    var newRest = Restaurant();

    newRest.id = "12";
    newRest.name = "GO PRO SUPPLY";
    newRest.latitude = "11";
    newRest.longitude = "12";
    newRest.deliveryFee = 40.0;
    newRest.distance = 0.0;

    _con?.restaurant = /* widget.routeArgument.param*/ newRest;
    _con?.listenForTrendingFoods(_con?.restaurant?.id ?? '');
    _con?.listenForCategories(_con?.restaurant?.id ?? '');
    selectedCategories = ['0'];
    _con?.listenForFoods(_con?.restaurant?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con?.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
            valueListenable: settingsRepo.setting,
            builder: (context, value, child) {
              return Text(
                (value).appName ?? S.of(context).home, // Safe null check
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.merge(TextStyle(letterSpacing: 1.3)),
              );
            }),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).colorScheme.secondary),
        ],
      ),
      /* appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: '0', param: _con.restaurant.id, heroTag: 'menu_tab')),
        ),
        title: Text(
          _con.restaurant?.name ?? '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),*/
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
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
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.bookmark,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).featured_foods,
                style: Theme.of(context).textTheme.headlineLarge ??
                    TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            FoodsCarouselWidget(
                heroTag: 'menu_trending_food',
                foodsList: (_con?.trendingFoods ?? [])),
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.subject,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).all_menu,
                style: Theme.of(context).textTheme.headlineLarge ??
                    TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            (_con?.categories.isEmpty ?? false)
                ? SizedBox(height: 90)
                : SizedBox(
                    height: 90,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate((_con?.categories.length ?? 0),
                          (index) {
                        var category = _con?.categories.elementAt(index);
                        var selected =
                            selectedCategories?.contains(category?.id) ?? false;
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: RawChip(
                            elevation: 0,
                            label: Text(category?.name ?? ''),
                            labelStyle: selected
                                ? Theme.of(context).textTheme.bodyMedium?.merge(
                                    TextStyle(
                                        color: Theme.of(context).primaryColor))
                                : Theme.of(context).textTheme.bodyMedium,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            backgroundColor:
                                Theme.of(context).focusColor.withOpacity(0.1),
                            selectedColor:
                                Theme.of(context).colorScheme.secondary,
                            selected: selected,
                            //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                            showCheckmark: false,
                            avatar: (category?.id == '0')
                                ? null
                                : ((category?.image?.url ?? '')
                                        .toLowerCase()
                                        .endsWith('.svg')
                                    ? SvgPicture.network(
                                        (category?.image?.url ?? ''),
                                        color: selected
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                      )
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: category?.image?.icon ?? '',
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/img/loading.gif',
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),
                            onSelected: (bool value) {
                              setState(() {
                                if (category?.id == '0') {
                                  selectedCategories = ['0'];
                                } else {
                                  selectedCategories?.removeWhere(
                                      (element) => element == '0');
                                }
                                if (value) {
                                  selectedCategories?.add(category?.id ?? '');
                                } else {
                                  selectedCategories?.removeWhere(
                                      (element) => element == category?.id);
                                }
                                _con?.selectCategory(selectedCategories ?? []);
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
            (_con?.foods.isEmpty ?? false)
                ? CircularLoadingWidget(height: 250)
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: (_con?.foods.length ?? 0),
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return FoodItemWidget(
                        heroTag: 'menu_list',
                        food: (_con?.foods.elementAt(index) ?? Food()),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
