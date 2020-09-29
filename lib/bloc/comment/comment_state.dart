


import 'package:equatable/equatable.dart';
import 'package:hackernews_flutter/model/comment.dart';

abstract class CommentState extends Equatable{
  @override
  List<Object> get props => throw UnimplementedError();
}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> listOfComment;
  final bool isMax;

  CommentLoaded({this.listOfComment, this.isMax});

  @override
  List<Object> get props => [listOfComment, isMax];

  CommentLoaded copywith({
    List<Comment> list,
    bool isMaxList,
  }) {
    return CommentLoaded(
      listOfComment: list ?? this.listOfComment,
      isMax: isMaxList ?? this.isMax
    );
  }

}

class CommentError extends CommentState {
  final String text;

  CommentError(this.text);
}