


import 'package:equatable/equatable.dart';
import 'package:hackernews_flutter/model/comment.dart';

abstract class CommentState extends Equatable{
  @override
  List<Object> get props => throw UnimplementedError();
}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> listOfComment;

  CommentLoaded({this.listOfComment});
}