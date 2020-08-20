


abstract class NewEvent {

}


class NewStoriesEvent extends NewEvent {
  final int start;

  final int limit;

  NewStoriesEvent({this.limit, this.start});
}


class RefreshNewStoriesEvent extends NewStoriesEvent {
  RefreshNewStoriesEvent(int start, int limit) : super(start:start, limit:limit);
}