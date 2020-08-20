import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/new/new_events.dart';
import 'package:hackernews_flutter/bloc/new/new_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hackernews_flutter/repository/new_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class NewBloc extends Bloc<NewEvent, NewState> {
  NewBloc(NewState initialState) : super(initialState);

  final NewRepository _newRepository = NewRepository();

  final cacheIdNew = [];

  bool isReachedMax(NewState state) => state is NewLoaded && state.isMax;

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
    final listId = await _newRepository.fetchIds(Endpoint.new_stories_ids);
    if (listId.isEmpty) yield NewLoaded(listStory: [], isMax: true);
    cacheIdNew.addAll(listId);

    final itemLimitStory =
        cacheIdNew.getRange(event.start, event.limit).map((e) {
      _newRepository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
      return _newRepository.fetchStories();
    }).toList();

    final listStories = await Future.wait(itemLimitStory);

    yield NewLoaded(
        listStory: listStories.where((element) => element != null).toList(),
        isMax: false);
  }

  Stream<NewState> newLoadMore(NewLoaded newLoadedState) async* {
    final lengthCurrentState = newLoadedState.listStory.length;
    print(lengthCurrentState);

    try {
      if (cacheIdNew.length > lengthCurrentState) {
        final listOfId = recursiveId(0, [], newLoadedState);
        final itemListNewStories = listOfId.map((e) {
          _newRepository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
          return _newRepository.fetchStories();
        }).toList();
        final listOfItem = await Future.wait(itemListNewStories);

        yield NewLoaded(
            listStory: newLoadedState.listStory + listOfItem.where((e) => e != null).toList(), isMax: false);
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
