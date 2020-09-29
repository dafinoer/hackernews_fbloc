


import 'package:equatable/equatable.dart';
import 'package:hackernews_flutter/model/story.dart';

abstract class TopState extends Equatable{
  @override
  List<Object> get props => [];
}


class TopLoading extends TopState {
}


class TopError extends TopState {
  final String txt;

  TopError({this.txt});
}


class TopLoaded extends TopState {

  final List<Story> listStory;

  bool isMax;

  TopLoaded({this.listStory, this.isMax});

  TopLoaded copyWith({
    List<Story> newListStory,
    bool isMaxStory
  }){
    return TopLoaded(
      listStory: newListStory ?? this.listStory,
      isMax: isMaxStory ?? this.isMax
    );
  }

  @override
  List<Object> get props => [listStory, isMax];
}