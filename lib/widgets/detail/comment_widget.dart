import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hackernews_flutter/model/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  Function htmlOnTap;

  CommentWidget(this.comment, this.htmlOnTap);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Html(
      data: comment.text,
      onLinkTap: htmlOnTap,
    ));
  }
}
