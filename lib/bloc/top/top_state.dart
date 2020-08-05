


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
    this.listStory.addAll(newListStory);
    this.isMax = isMaxStory;
  }
}

class TopIds extends TopState {
  List<int> topIds;

  bool isMax;

  TopIds({this.topIds, this.isMax});

  TopIds copyWith({
    List<int> newIds,
    bool isMax
  }){
    topIds.addAll(newIds);
    this.isMax = isMax;
  } 
}