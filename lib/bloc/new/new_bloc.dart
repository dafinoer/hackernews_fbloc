import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/api/core_source.dart';
import 'package:hackernews_flutter/bloc/new/new_events.dart';
import 'package:hackernews_flutter/bloc/new/new_state.dart';
import 'package:hackernews_flutter/common/remote/config/dio_module.dart';
import 'package:hackernews_flutter/repository/new_news/new_repository_impl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hackernews_flutter/repository/new_repository.dart';

class NewBloc extends Bloc<NewEvent, NewState> {
  NewBloc(NewState initialState) : super(initialState);
  
  final cacheIdNew = [];

  bool isReachedMax(NewState state) => state is NewLoaded && state.isMax;

  NewRepositoryImpl _impl =
      NewRepositoryImpl(BaseSource(DioModule.getInstance()));

  @override
  Stream<Transition<NewEvent, NewState>> transformEvents(
      Stream<NewEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<NewState> mapEventToState(NewEvent event) async* {
    final currentState = state;
    try {
      if (event is NewStoriesEvent && !isReachedMax(currentState)) {
        if (currentState is NewLoading) {
          yield* loadingState(event);
        }
        if (currentState is NewLoaded) {
          yield* newLoadMore(currentState);
        }
      }
      if (event is RefreshNewStoriesEvent) {
        cacheIdNew.clear();
        yield* loadingState(event);
      }
    } catch (e) {
      yield NewError(txt: e.toString());
    }
  }

  Stream<NewState> loadingState(NewStoriesEvent event) async* {
    final listId = await _impl.getIds();
    if (listId.isEmpty) yield NewLoaded(listStory: [], isMax: true);

    cacheIdNew.addAll(listId.take(50));
    final itemResults = await _impl.getStories(listId.take(10).toList());

    yield NewLoaded(
        listStory: itemResults,
        isMax: false);
  }

  Stream<NewState> newLoadMore(NewLoaded newLoadedState) async* {
    final lengthCurrentState = newLoadedState.listStory.length;

    try {
      if (cacheIdNew.length > lengthCurrentState) {
        final listOfId = recursiveId(0, [], newLoadedState);
        final items = await _impl.getStories(listOfId);

        yield NewLoaded(
            listStory: newLoadedState.listStory + items,
            isMax: false);
      } else {
        yield newLoadedState.copyWith(isMaxList: true);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  List<int> recursiveId(int total, List<int> params, NewLoaded newLoadedState) {
    if (total < 10 &&
        newLoadedState.listStory.length + total < cacheIdNew.length) {
      params.add(cacheIdNew[newLoadedState.listStory.length + total]);
      total += 1;
      return recursiveId(total, params, newLoadedState);
    } else {
      return params;
    }
  }
}
