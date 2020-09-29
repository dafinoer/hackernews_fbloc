
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:hackernews_flutter/api/top_source.dart';
import 'package:hackernews_flutter/bloc/top/top_event.dart';
import 'package:hackernews_flutter/bloc/top/top_state.dart';
import 'package:hackernews_flutter/common/remote/config/dio_module.dart';
import 'package:hackernews_flutter/repository/home/home_repository_imp.dart';
import 'package:hackernews_flutter/repository/topstories_repository.dart';
import 'package:rxdart/rxdart.dart';

class TopBloc extends Bloc<TopEvent, TopState> {
  TopBloc(TopState initialState) : super(initialState);

  final TopStoriesRepository repository = TopStoriesRepository();

  final TopRepositoryImp _repo =
      TopRepositoryImp(TopSource(DioModule.getInstance()));

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
      } else if (event is RefreshIndicatorState) {
        cacheIds.clear();
        yield* loadingState(event);
      }
    } catch (e) {
      yield TopError(txt: e.toString());
    }
  }

  Stream<TopState> loadingState(TopIdEvent event) async* {
    final itemResult = await _repo.getTopIds();

    if (itemResult.isNotEmpty) {
      cacheIds.addAll(itemResult.take(50).toList());
      final results = await _repo.getStories(itemResult.take(10).toList());
      yield TopLoaded(isMax: false, listStory: results);
    }
  }

  Stream<TopState> moreDataLoading(TopLoaded currentState) async* {
    final nextLimit = currentState.listStory.length;

    if (cacheIds.length > nextLimit) {
      final itemCacheId = recursiveStory(0, currentState, []);
      final results = await _repo.getStories(itemCacheId);
      yield TopLoaded(listStory: currentState.listStory + results, isMax: false);
    } else {
      yield currentState.copyWith(
        isMaxStory: true,
      );
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
}
