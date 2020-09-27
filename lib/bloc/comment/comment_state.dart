


import 'package:equatable/equatable.dart';
import 'package:hackernews_flutter/model/comment.dart';

abstract class CommentState extends Equatable{
  @override
  List<Object> get props => throw UnimplementedError();
}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> listOfComment;

  final List<Map<String, dynamic>> listValue;

  CommentLoaded({this.listOfComment, this.listValue});
}

class CommentError extends CommentState {
  final String text;

  CommentError(this.text);
}