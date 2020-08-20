
abstract class JobEvent {

}

class EventIndexStart extends JobEvent{
  final int start;

  final int limit;

  EventIndexStart({this.start, this.limit});
}

class PullRefreshIndex extends EventIndexStart {
  PullRefreshIndex(int start, int limit) : super(start: start, limit: limit);
}