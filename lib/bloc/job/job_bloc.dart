import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/bloc/job/job_event.dart';
import 'package:hackernews_flutter/bloc/job/job_state.dart';
import 'package:hackernews_flutter/common/remote/config/dio_module.dart';
import 'package:hackernews_flutter/repository/jobs/job_repository_imp.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hackernews_flutter/api/core_source.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc(JobState initialState) : super(initialState);

  JobRepositoryImpl repositoryImpl =
      JobRepositoryImpl(BaseSource(DioModule.getInstance()));

  final cacheId = [];

  bool _isMax(JobState state) => state is JobLoaded && state.isMax;

  @override
  Stream<Transition<JobEvent, JobState>> transformEvents(
      Stream<JobEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<JobState> mapEventToState(JobEvent event) async* {
    final currentState = state;
    try {
      if (event is EventIndexStart && !_isMax(state)) {
        if (currentState is JobsLoading) {
          yield* loadingStream(event);
        } else if (currentState is JobLoaded) {
          yield* infiniteItem(currentState);
        }
      }
    } catch (e) {
      yield JobError(txt: e.toString());
    }
  }

  Stream<JobState> loadingStream(EventIndexStart event) async* {
    final result = await repositoryImpl.getIds();

    if (result.isNotEmpty) {
      cacheId.addAll(result.take(50).toList());
      final limitId = result.take(10).toList();
      final dataIds = await repositoryImpl.getStories(limitId);

      yield JobLoaded(listOfJobs: dataIds, isMax: false);
    } else {
      yield JobLoaded(isMax: true, listOfJobs: []);
    }
  }

  Stream<JobState> infiniteItem(JobLoaded jobLoadedState) async* {
    final jobsListLength = jobLoadedState.listOfJobs.length;

    if (cacheId.length > jobsListLength) {
      final indexIds = recursiveId(0, [], jobLoadedState);
      final items = await repositoryImpl.getStories(indexIds);

      yield JobLoaded(
          listOfJobs: jobLoadedState.listOfJobs + items, isMax: false);
    } else {
      yield jobLoadedState.copyWith(isMax: true);
    }
  }

  List<int> recursiveId(int total, List<int> params, JobLoaded jobLoaded) {
    final lengtNow = jobLoaded.listOfJobs.length + total;
    if (total < 5 && lengtNow < cacheId.length) {
      params.add(cacheId[jobLoaded.listOfJobs.length + total]);
      total += 1;
      return recursiveId(total, params, jobLoaded);
    } else {
      return params;
    }
  }
}
