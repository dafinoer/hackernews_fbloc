


import 'package:hackernews_flutter/model/story.dart';

abstract class TopState {

}


class TopLoading extends TopState {}


class TopError extends TopState {
  final String txt;

  TopError({this.txt});
}


class TopLoaded extends TopState {

  List<Story> listStory;

  bool isMax;

  TopLoaded({this.listStory, this.isMax});

  TopLoaded copyWith({
    List<Story> newListStory,
    bool isMaxStory
  }){
    return TopLoaded(
      listStory: newListStory ?? this.listStory,
      isMax: isMax ?? this.isMax
    );
  }
}