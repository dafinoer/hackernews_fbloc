


import 'package:equatable/equatable.dart';
import 'package:hackernews_flutter/model/story.dart';

abstract class NewState extends Equatable{
  @override
  List<Object> get props => [];
}


class NewLoading extends NewState {}

class NewError extends NewState {
  final String txt;

  NewError({this.txt});
}

class NewLoaded extends NewState with EquatableMixin{

  final List<Story> listStory;

  final bool isMax;

  NewLoaded({this.listStory, this.isMax});

  NewLoaded copyWith({
    List<Story> newListStory,
    bool isMaxList
  }){
    return NewLoaded(
      listStory: newListStory ?? this.listStory,
      isMax: isMaxList ?? this.isMax
    );
  }

  @override
  List<Object> get props => super.props..addAll([listStory, isMax]);
}