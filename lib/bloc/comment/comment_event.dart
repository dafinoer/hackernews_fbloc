

import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class CommentListOfId extends CommentEvent {
  final List<int> listOfKids;

  CommentListOfId({this.listOfKids});
}