

import 'package:equatable/equatable.dart';
import 'package:hackernews_flutter/model/comment.dart';

abstract class CommentEvent extends Equatable{
  @override
  List<Object> get props => [];
}


class CommentListOfId extends CommentEvent {
  final List<int> listOfKids;

  CommentListOfId({this.listOfKids});
}


class CommentItem extends CommentEvent {
  final Comment comment;
  CommentItem(this.comment);
}