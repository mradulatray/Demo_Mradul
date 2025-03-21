import 'package:flutter/material.dart';

import '../models/favorite.dart';
import '../models/route_argument.dart';

class FavoriteGridItemWidget extends StatelessWidget {
  final String heroTag;
  final Favorite favorite;

  FavoriteGridItemWidget(
      {Key? key, required this.heroTag, required this.favorite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Food',
            arguments: new RouteArgument(
                heroTag: this.heroTag, id: this.favorite.food?.id ?? ''));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: heroTag + (favorite.food?.id ?? ''),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              this.favorite.food?.image?.thumb ?? ''),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                favorite.food?.name ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                favorite.food?.restaurant?.name ?? '',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: MaterialButton(
              elevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              padding: EdgeInsets.all(0),
              onPressed: () {},
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
