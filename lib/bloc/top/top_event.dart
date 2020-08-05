

abstract class TopEvent {

}

class TopIdEvent extends TopEvent {
  final int limit;

  final int indexStart;

  TopIdEvent({this.limit, this.indexStart});
}