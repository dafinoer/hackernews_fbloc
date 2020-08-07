import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hackernews_flutter/bloc/comment/comment_bloc.dart';
import 'package:hackernews_flutter/bloc/comment/comment_event.dart';
import 'package:hackernews_flutter/bloc/comment/comment_state.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/function_helper.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:hackernews_flutter/widgets/detail/text_and_icon_widget.dart';
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';


class DetailPage extends StatefulWidget {
  static const routeName = '/detail-hackernews';

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> {
  CommentBloc _commentBloc;

  @override
  void initState() {
    _commentBloc = CommentBloc(CommentLoading());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final DetailArguments args = ModalRoute.of(context).settings.arguments;
    print(args.story.kids);
    _commentBloc.add(CommentListOfId(listOfKids: args.story.kids));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _commentBloc.close();
    super.dispose();
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: space_4x, vertical: space_4x),
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
                    fisrtTitleIcon: FuntionHelper.diffWithText(args.story.time),
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
                  ),
                  listComment(args.story.kids),
                ],
              ),
            ),
          ),
        ));
  }

  Widget listComment(List<int> commentId) {
    return BlocBuilder<CommentBloc, CommentState>(
        cubit: _commentBloc,
        builder: (_, state) {
          if (state is CommentLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CommentLoaded) {
            return ListView.separated(
                separatorBuilder: (_, index) => Divider(),
                itemCount: state.listOfComment.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: space_4x),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final txt = parse(state.listOfComment[index].text);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Html(
                      data: state.listOfComment[index].text,
                      onLinkTap: (link) async {
                        var url = link.toString();
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  );
                });
          }
        });
  }
}
