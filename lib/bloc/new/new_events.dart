


abstract class NewEvent {

}


class NewStoriesEvent extends NewEvent {
  final int start;

  final int limit;

  NewStoriesEvent({this.limit, this.start});
}