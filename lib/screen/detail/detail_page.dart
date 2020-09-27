import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/comment/comment_bloc.dart';
import 'package:hackernews_flutter/bloc/comment/comment_event.dart';
import 'package:hackernews_flutter/bloc/comment/comment_state.dart';
import 'package:hackernews_flutter/repository/comment_repository.dart';
import 'package:hackernews_flutter/utils/detail_arguments.dart';
import 'package:hackernews_flutter/utils/function_helper.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:hackernews_flutter/widgets/detail/link_widget.dart';
import 'package:hackernews_flutter/widgets/detail/list_comment_widget.dart';
import 'package:hackernews_flutter/widgets/detail/text_and_icon_widget.dart';
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
  CommentRepository _commentRepository = CommentRepository();

  @override
  void initState() {
    _commentBloc = CommentBloc(CommentLoading());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final DetailArguments args = ModalRoute.of(context).settings.arguments;
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

    return Scaffold(
        appBar: AppBar(
          title: Text(args.story.type),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: space_4x, horizontal: space_4x),
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
                    secondIcon: Icons.favorite_border,
                    secondTitleIcon: args.story.score.toString(),
                  ),
                  TextAndIconWidget(
                    isMarginRight: false,
                    isMArginLeft: false,
                    firstIcon: Icons.query_builder,
                    fisrtTitleIcon: FuntionHelper.diffWithText(args.story.time),
                    secondIcon: Icons.chat_bubble_outline,
                    secondTitleIcon: args.story.descendants.toString(),
                  ),
                  LinkWidget(
                    arguments: args,
                  ),
                  listComment(args.story.kids),
                ],
              ),
            ),
          ),
        ));
  }

  Widget listComment(List<int> commentId) {
    return BlocProvider.value(
      value: _commentBloc,
      child: ListCommentWidget(),
    );
  }
}
