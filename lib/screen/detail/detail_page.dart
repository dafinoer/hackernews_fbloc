import 'package:flutter/material.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:hackernews_flutter/widgets/detail/text_and_icon_widget.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail-hackernews';

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DetailArguments args = ModalRoute.of(context).settings.arguments;
    final themes = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(args.story.type),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: space_4x, vertical: space_4x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  args.story.title,
                  style: themes.textTheme.headline6,
                ),
                Container(
                  child: Divider(),
                  margin: EdgeInsets.symmetric(vertical: space_4x),
                ),
                TextAndIconWidget(
                  isMarginTop: false,
                  isMarginBottom: false,
                  isMArginLeft: false,
                  isMarginRight: false,
                  firstIcon: Icons.perm_identity,
                  fisrtTitleIcon: args.story.by,
                  secondIcon: Icons.grade,
                  secondTitleIcon: args.story.score.toString(),
                ),
                TextAndIconWidget(
                  isMarginRight: false,
                  isMArginLeft: false,
                  firstIcon: Icons.query_builder,
                  fisrtTitleIcon: args.story.by,
                  secondIcon: Icons.chat_bubble_outline,
                  secondTitleIcon: args.story.kids.length.toString(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.language,
                      size: 12.0 * mediaQuery.devicePixelRatio,
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: space_1x),
                      child: GestureDetector(
                        child: Text(
                          args.story.url,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
