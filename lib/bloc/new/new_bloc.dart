import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/new/new_events.dart';
import 'package:hackernews_flutter/bloc/new/new_state.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/repository/new_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class NewBloc extends Bloc<NewEvent, NewState> {
  NewBloc(NewState initialState) : super(initialState);

  final NewRepository _newRepository = NewRepository();

  final cacheIdNew = [];

  bool isReachedMax(NewState state) => state is NewLoaded && state.isMax;

  @override
  Stream<NewState> mapEventToState(NewEvent event) async* {
    final currentState = state;
    try {
      if (event is NewStoriesEvent && !isReachedMax(currentState)) {
        if (currentState is NewLoading) {
          yield* loadingState(event);
        } else if (currentState is NewLoaded) {
          loadedState(currentState);
        }
      }
    } catch (e) {
      yield NewError(txt: e.toString());
    }
  }

  Stream<NewState> loadingState(NewStoriesEvent event) async* {
    final listId = await _newRepository.fetchIds(Endpoint.new_stories_ids);

    if (listId.isEmpty) {
      yield NewLoaded(listStory: [], isMax: true);
    }

    cacheIdNew.addAll(listId);

    final itemLimitStory =
        cacheIdNew.getRange(event.start, event.limit).map((e) {
      _newRepository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
      return _newRepository.fetchStories();
    });

    final listStories = await Future.wait(itemLimitStory);

    yield NewLoaded(listStory: listStories, isMax: false);
  }

  Stream<NewState> loadedState(NewLoaded newLoadedState) async* {
    final listOfId = recursiveId(0, [], newLoadedState);
    print(listOfId);
  }

  List<int> recursiveId(int total, List<int> params, NewLoaded newLoadedState) {
    if (total < 5 &&
        newLoadedState.listStory.length + total < cacheIdNew.length) {
      params.add(cacheIdNew[newLoadedState.listStory.length + total]);
      total += 1;
      return recursiveId(total, params, newLoadedState);
    } else {
      return params;
    }
  }
}
