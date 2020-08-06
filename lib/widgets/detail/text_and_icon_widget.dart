import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hackernews_flutter/utils/values.dart';

class TextAndIconWidget extends StatelessWidget {
  final bool isMarginTop;
  final bool isMArginLeft;
  final bool isMarginBottom;
  final bool isMarginRight;

  final IconData firstIcon;
  final IconData secondIcon;
  final String fisrtTitleIcon;
  final String secondTitleIcon;

  TextAndIconWidget(
      {this.isMArginLeft = true,
      this.isMarginBottom = true,
      this.isMarginTop = true,
      this.isMarginRight = true,
      this.firstIcon,
      this.secondIcon,
      this.fisrtTitleIcon,
      this.secondTitleIcon});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.only(
          top: isMarginTop ? space_4x : 0.0,
          left: isMArginLeft ? space_4x : 0.0,
          bottom: isMarginBottom ? space_4x : 0.0,
          right: isMarginRight ? space_4x : 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: iconAndText(
            context,
            icon: Icon(
              firstIcon,
              size: 12.0 * mediaQuery.devicePixelRatio,
            ),
            text: fisrtTitleIcon,
          )),
          Expanded(
              child: iconAndText(context,
                  icon: Icon(
                    secondIcon,
                    size: 12.0 * mediaQuery.devicePixelRatio,
                  ),
                  text: secondTitleIcon)),
        ],
      ),
    );
  }

  Widget iconAndText(BuildContext contextParam,
      {@required Icon icon, @required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        icon,
        Padding(
          padding: const EdgeInsets.only(left: space_1x),
          child: Text(
            text,
            style: Theme.of(contextParam).textTheme.subtitle2,
          ),
        )
      ],
    );
  }
}
