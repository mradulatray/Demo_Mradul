import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/extra.dart';

class ExtraItemWidget extends StatefulWidget {
  final Extra? extra;
  final VoidCallback? onChanged;

  ExtraItemWidget({
    Key? key,
    this.extra,
    this.onChanged,
  }) : super(key: key);

  @override
  _ExtraItemWidgetState createState() => _ExtraItemWidgetState();
}

class _ExtraItemWidgetState extends State<ExtraItemWidget>
    with SingleTickerProviderStateMixin {
  Animation? animation;
  AnimationController? animationController;
  Animation<double>? sizeCheckAnimation;
  Animation<double>? rotateCheckAnimation;
  Animation<double>? opacityAnimation;
  Animation? opacityCheckAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    if (animationController != null) {
      CurvedAnimation curve =
          CurvedAnimation(parent: animationController!, curve: Curves.easeOut);
      animation = Tween(begin: 0.0, end: 60.0).animate(curve)
        ..addListener(() {
          setState(() {});
        });
      opacityAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
        ..addListener(() {
          setState(() {});
        });
      opacityCheckAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
        ..addListener(() {
          setState(() {});
        });
      rotateCheckAnimation = Tween(begin: 2.0, end: 0.0).animate(curve)
        ..addListener(() {
          setState(() {});
        });
      sizeCheckAnimation = Tween<double>(begin: 0, end: 36).animate(curve)
        ..addListener(() {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.extra?.checked ?? false) {
          animationController?.reverse();
        } else {
          animationController?.forward();
        }
        widget.extra?.checked = !(widget.extra?.checked ?? true);
        if (widget.onChanged != null) {
          widget.onChanged!();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  image: DecorationImage(
                      image: NetworkImage(widget.extra?.image?.thumb ?? ""),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                height: animation?.value,
                width: animation?.value,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(opacityAnimation?.value ?? 0),
                ),
                child: Transform.rotate(
                  angle: rotateCheckAnimation?.value ?? 0,
                  child: Icon(
                    Icons.check,
                    size: sizeCheckAnimation?.value,
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(opacityCheckAnimation?.value),
                  ),
                ),
              ),
            ],
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
                        widget.extra?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        Helper.skipHtml(widget.extra?.description ?? ""),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Helper.getPrice(widget.extra?.price ?? 0, context,
                    style: Theme.of(context).textTheme.headlineLarge ??
                        TextStyle(fontSize: 18)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
