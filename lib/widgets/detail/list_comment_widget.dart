
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hackernews_flutter/bloc/comment/bloc.dart';
import 'package:hackernews_flutter/bloc/comment/comment_bloc.dart';
import 'package:hackernews_flutter/bloc/comment/comment_state.dart';
import 'package:hackernews_flutter/model/comment.dart';
import 'package:hackernews_flutter/utils/values.dart';
import 'package:hackernews_flutter/widgets/detail/comment_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ListCommentWidget extends StatelessWidget {
  BuildContext _listCommentContext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _listCommentContext = context;

    return BlocBuilder<CommentBloc, CommentState>(
        cubit: BlocProvider.of<CommentBloc>(context),
        builder: (_, state) {
          if (state is CommentLoading) {
            return Padding(
              padding: EdgeInsets.only(top: space_4x),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is CommentLoaded && state.listOfComment.isNotEmpty) {
            return ListView.separated(
                separatorBuilder: (_, index) => Divider(),
                itemCount: state.listOfComment.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: space_4x),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return CommentWidget(state.listOfComment[index]);
                });
          }

          if (state is CommentLoaded && state.listOfComment.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: space_4x),
              child: Center(
                  child: Text(
                'No Comment',
                style: theme.textTheme.subtitle2,
              )),
            );
          }

          if (state is CommentError) {
            return Padding(
              padding: EdgeInsets.only(top: space_4x),
              child: Center(
                  child: Text(
                'upps something wrong',
                style: theme.textTheme.subtitle2,
              )),
            );
          }
          return const SizedBox();
        });
  }

  Widget buttonLoadWidget(Comment comment) {
    return FlatButton(
        onPressed: () => _onTapLoadComment(comment),
        child: Text(comment.kids.length.toString() + ' Comments'));
  }

  void _onTapUrl(String link) async {
    var url = link.toString();
    if (await canLaunch(url)) await launch(url);
    else throw 'Could not launch $url';
  }

  void _onTapLoadComment(Comment comment) {
    _listCommentContext.bloc<CommentBloc>().add(CommentItem(comment));
  }
}
