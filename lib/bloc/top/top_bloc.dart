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

  final TopStoriesRepository repository = TopStoriesRepository();

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

  Stream<TopState> loadingState(TopIdEvent event) async* {
    final listId = await repository.fetchIds(Endpoint.top_stories_ids);

    if (listId.isNotEmpty) {
      cacheIds.addAll(listId);
      final listTemp = listOfStory(cacheIds, start: event.indexStart, limit: event.limit);

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
      yield currentState.copyWith(isMaxStory: true,);
    }
  }

  List<int> recursiveStory(
      int total, TopLoaded loadedList, List<int> paramsStoryId) {
    if (total < 10 && loadedList.listStory.length + total < cacheIds.length) {
      paramsStoryId.add(cacheIds[loadedList.listStory.length + total]);
      total += 1;
      return recursiveStory(total, loadedList, paramsStoryId);
    } else {
      return paramsStoryId;
    }
  }

  List<Future<Story>> listOfStory(List<int> paramsId, {int start, int limit}) {
    var temps = [];
    try {
      if (start != null && limit != null) {
        temps = paramsId.getRange(start, limit).map((e) {
          repository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
          return repository.fetchStories();
        }).toList();
      } else {
        temps = paramsId.map((e) {
          repository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
          return repository.fetchStories();
        }).toList();
      }
      return temps;
    } catch (e) {
      throw Exception(e);
    }
  }
}
