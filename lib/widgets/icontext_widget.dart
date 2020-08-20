import 'package:flutter/material.dart';
import 'package:hackernews_flutter/utils/values.dart';

class IconTextWidget extends StatelessWidget {
  final IconData typeIcon;

  final String text;

  IconTextWidget({Key key, @required this.text, @required this.typeIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          typeIcon,
          size: space_4x,
        ),
        Padding(
          padding: const EdgeInsets.only(left: space_1x),
          child: Text(
            text,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        )
      ],
    );
  }
}
