import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews_flutter/api/ids_topstories_services.dart';
import 'package:hackernews_flutter/bloc/job/job_event.dart';
import 'package:hackernews_flutter/bloc/job/job_state.dart';
import 'package:hackernews_flutter/repository/jobs_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';
import 'package:rxdart/rxdart.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc(JobState initialState) : super(initialState);

  JobsRepository _repository = JobsRepository();

  IdsServices _idsServices = IdsServices();

  final cacheId = [];

  bool _isMax(JobState state) => state is JobLoaded && state.isMax;

  @override
  Stream<Transition<JobEvent, JobState>> transformEvents(Stream<JobEvent> events, transitionFn) {
    return super.transformEvents(events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<JobState> mapEventToState(JobEvent event) async* {
    final currentState = state;
    try {
      if(event is EventIndexStart && !_isMax(state)){
        if(currentState is JobsLoading){
          yield* loadingStream(event);
        } else if(currentState is JobLoaded){
          yield* infiniteItem(currentState);
        }
      }
    } catch (e) {
      yield JobError(txt: e.toString());
    }
  }

  Stream<JobState> loadingStream(EventIndexStart event) async* {
    final result = await _idsServices.fetchIds(Endpoint.job_stories_id);

    if (result.isNotEmpty) {
      cacheId.addAll(result);
      final limitId = cacheId.getRange(event.start, event.limit).toList();

      final dataId = limitId.map((e) {
        _repository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
        return _repository.fetchJobs();
      }).toList();

      final jobsList = await Future.wait(dataId);
      yield JobLoaded(listOfJobs: jobsList, isMax: false);
    } else {
      yield JobLoaded(isMax: true, listOfJobs: []);
    }
  }

  Stream<JobState> infiniteItem(JobLoaded jobLoadedState) async* {
    final jobsListLength = jobLoadedState.listOfJobs.length;

    if(cacheId.length > jobsListLength){
      final indexIds = recursiveId(0, [], jobLoadedState);
      final dataId = indexIds.map((e) {
        _repository.setUrl(Endpoint.item.replaceAll('{id}', e.toString()));
        return _repository.fetchJobs();
      });
      
      final newJobList = await Future.wait(dataId);

      yield JobLoaded(listOfJobs: jobLoadedState.listOfJobs + newJobList, isMax: false);
    } else {
      yield jobLoadedState.copyWith(
        isMax: true
      );
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
