import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:hackernews_flutter/bloc/top/top_event.dart';
import 'package:hackernews_flutter/bloc/top/top_state.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/repository/topstories_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';
import 'package:rxdart/rxdart.dart';

class TopBloc extends Bloc<TopEvent, TopState> {
  TopBloc(TopState initialState) : super(initialState);

  final TopStoriesRepository _repository = TopStoriesRepository();

  final List<int> cacheIds = [];

  bool hasReachedMax(TopState topState) =>
      topState is TopLoaded && topState.isMax;

  @override
  Stream<Transition<TopEvent, TopState>> transformEvents(
      Stream<TopEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<TopState> mapEventToState(TopEvent event) async* {
    final currentState = state;

    try {
      if (event is TopIdEvent && !hasReachedMax(currentState)) {
        if (state is TopLoading) {
          yield* loadingState(event);
        }
        if (currentState is TopLoaded) {
          yield* moreDataLoading(currentState);
        }
      }
    } catch (e) {
      yield TopError(txt: e.toString());
    }
  }

  bool get isMax => state is TopLoaded;

  Stream<TopState> loadingState(TopIdEvent event) async* {
    final listId = await _repository.idsTopStories();

    if (listId.isNotEmpty) {
      cacheIds.addAll(listId);

      final listTemp = listOfStory(cacheIds);

      var listData = await Future.wait(listTemp);
      yield TopLoaded(isMax: false, listStory: listData);
    }
  }

  Stream<TopState> moreDataLoading(TopLoaded currentState) async* {
    final nextLimit = currentState.listStory.length;

    if (cacheIds.length > nextLimit) {
      final itemCacheId = recursiveStory(0, currentState, []);

      final listTemp = listOfStory(itemCacheId);
      
      final listNewLoadedStory = await Future.wait(listTemp);

      yield TopLoaded(
          listStory: currentState.listStory + listNewLoadedStory, isMax: false);
    } else {
      yield currentState.copyWith(isMaxStory: true);
    }
  }

  List<int> recursiveStory(
      int total, TopLoaded loadedList, List<int> paramsStoryId) {
    if (total < 10 && loadedList.listStory.length + total <= cacheIds.length) {
      total += 1;
      paramsStoryId.add(cacheIds[loadedList.listStory.length + total]);
      return recursiveStory(total, loadedList, paramsStoryId);
    } else {
      return paramsStoryId;
    }
  }

  List<Future<Story>> listOfStory(List<int> paramsId) => paramsId.map((e){
     _repository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
     return _repository.getFromServerTopStories();
  });
}
