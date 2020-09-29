import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hackernews_flutter/bloc/comment/bloc.dart';
import 'package:hackernews_flutter/model/comment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  BuildContext cntx;

  CommentWidget(this.comment);

  @override
  Widget build(BuildContext context) {
    cntx = context;
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(width: 5.0, color: Colors.deepOrange[100]))),
      child: ExpansionTile(
        children: comment.listComment != null ? comment.listComment.map((e) => CommentWidget(e)).toList() : [],
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Container(
          child: Html(
            data: comment.text,
            onLinkTap: _onTapUrl,
          ),
        ),
        onExpansionChanged: (value) {
          if (comment.listComment != null &&
              comment.listComment.isEmpty &&
              value) {
            _onTapLoadComment(comment);
          }
        },
        // subtitle: state.listOfComment[index] != null &&
        //         state.listOfComment[index].kids.isNotEmpty
        //     ? buttonLoadWidget(state.listOfComment[index])
        //     : const SizedBox(),
      ),
    );
  }

  Widget buttonLoadWidget(Comment comment) {
    return FlatButton(
        onPressed: () => _onTapLoadComment(comment),
        child: Text(comment.kids.length.toString() + ' Comments'));
  }

  void _onTapUrl(String link) async {
    var url = link.toString();
    if (await canLaunch(url))
      await launch(url);
    else
      throw 'Could not launch $url';
  }

  void _onTapLoadComment(Comment comment) {
    cntx.bloc<CommentBloc>().add(CommentItem(comment));
  }
}
