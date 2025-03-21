import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../helpers/app_config.dart' as config;

class DeliveryAddressBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  DeliveryAddressBottomSheetWidget({Key? key, required this.scaffoldKey})
      : super(key: key);

  @override
  _DeliveryAddressBottomSheetWidgetState createState() =>
      _DeliveryAddressBottomSheetWidgetState();
}

class _DeliveryAddressBottomSheetWidgetState
    extends StateMVC<DeliveryAddressBottomSheetWidget> {
  late DeliveryAddressesController _con;

  _DeliveryAddressBottomSheetWidgetState()
      : super(DeliveryAddressesController()) {
    _con = controller as DeliveryAddressesController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.4),
              blurRadius: 30,
              offset: Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView(
              padding:
                  EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pushNamed("/PickAddress");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Theme.of(context).focusColor),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                          size: 22,
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
                                    S.of(context).add_new_delivery_address,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: () {
                    _con.changeDeliveryAddressToCurrentLocation().then((value) {
                      if (widget.scaffoldKey.currentContext != null) {
                        Navigator.of(widget.scaffoldKey.currentContext!).pop();
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Theme.of(context).colorScheme.secondary),
                        child: Icon(
                          Icons.my_location,
                          color: Theme.of(context).primaryColor,
                          size: 22,
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
                                    S.of(context).current_location,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.addresses.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 25);
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _con
                            .changeDeliveryAddress(
                                _con.addresses.elementAt(index))
                            .then((value) {
                          if (widget.scaffoldKey.currentContext != null) {
                            Navigator.of(widget.scaffoldKey.currentContext!)
                                .pop();
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Theme.of(context).focusColor),
                            child: Icon(
                              Icons.place,
                              color: Theme.of(context).primaryColor,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 15),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        (_con.addresses
                                                .elementAt(index)
                                                .address ??
                                            ''),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(context).focusColor,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 13, horizontal: config.App(context).appWidth(42)),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              //child: SizedBox(height: 1,),
            ),
          ),
        ],
      ),
    );
  }
}
