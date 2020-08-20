

abstract class TopEvent {

}

class TopIdEvent extends TopEvent {
  final int limit;

  final int indexStart;

  TopIdEvent({this.limit, this.indexStart});
}


class RefreshPullRequest extends TopIdEvent{
  RefreshPullRequest(int start, int limit) : super(limit: start, indexStart:limit);
}