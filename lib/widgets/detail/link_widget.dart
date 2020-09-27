import 'package:flutter/material.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkWidget extends StatelessWidget {
  final DetailArguments arguments;

  LinkWidget({this.arguments, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: _onTap,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.language,
              size: 12.0 * media.devicePixelRatio,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: space_1x),
              child: GestureDetector(
                child:  Text(
                  arguments.story.url,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.blue[400]),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _onTap() async {
    bool isCanLaunch = await canLaunch(arguments.story.url);
    if (isCanLaunch) {
      await launch(arguments.story.url);
    } else {
      print('error');
    }
  }
}
