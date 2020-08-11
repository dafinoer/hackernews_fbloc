import 'package:hackernews_flutter/model/job.dart';

abstract class JobState {}

class JobsLoading extends JobState {}

class JobLoaded extends JobState {
  final List<Job> listOfJobs;
  final bool isMax;

  JobLoaded({this.listOfJobs, this.isMax});

  JobLoaded copyWith({List<Job> listNewJob, bool isMax}) {
    return JobLoaded(
        listOfJobs: listOfJobs ?? this.listOfJobs, isMax: isMax ?? this.isMax);
  }
}

class JobError extends JobState {
  final String txt;

  JobError({this.txt});
}
